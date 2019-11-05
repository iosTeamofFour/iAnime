//
//  DraftingViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/23.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class DraftingViewController: DraftingPinchViewController {

    @IBOutlet weak var Toolbar: UIView!
    @IBOutlet weak var PickedColorIndicator: RoundCornerUIImageView!
    private var PickedColor = RGB(R:0,G:0,B:0)
    
    // 主绘制区域
    @IBOutlet weak var drawing: DrawingView! // 绘制层
    @IBOutlet weak var background: UIImageView!  // 背景图片层
    private var OriginBounds : CGRect!
    var shouldLoadBackground : UIImage?
    
    // 工具条区域
    @IBOutlet weak var UndoBtn: UIButton!
    @IBOutlet weak var RedoBtn: UIButton!
    @IBOutlet weak var EraserBtn: UIButton!
    @IBOutlet weak var ColorAnchorBtn: UIButton!
    @IBOutlet weak var ColorHintBtn: UIButton!

    private var LastClieckedBtn : UIButton?
    
    // 下方多功能按键呼出
    @IBOutlet weak var MultifuncBtn: UIButton!
    
    // --------------- 提示类信息 -----------------
    private var HadShownEditingTypeHint = false
    
    // ------------- 重写提供给父类的变量 -------------------
    
    override var imageView: UIImageView! {
        get {
            return drawing
        }
    }
    
    override var backgroundIv: UIImageView! {
        get {
            return background
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawing.draftingController = self
        background.image = shouldLoadBackground
        OriginBounds = CGRect(x: 0, y: 0, width: drawing.bounds.width, height: drawing.bounds.height)
        AttachGestureRecognizerToImageView(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DrawRoundCircile()
    }
    
    @IBAction func HandleReturn(_ sender: UIButton) {
        if let naviController = navigationController {
            naviController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func OnScaling(_ currentScaling : CGFloat) {
        drawing.FixColorPointSize(currentScaling)
    }
    
    // 与子View的通信函数
    func NotifyCanUndo () {
        UndoBtn.isEnabled = true
    }
    
    func NotifyCanRedo() {
        RedoBtn.isEnabled = true
    }
    
    func NofityCanNotRedo() {
        RedoBtn.isEnabled = false
    }
    
    @IBAction func HandleRedo(_ sender: UIButton) {
        sender.isEnabled = drawing.HandleRedo()
    }
    @IBAction func HandleUndo(_ sender: UIButton) {
        sender.isEnabled = drawing.HandleUndo()
    }
    
    private func BackToPinchMode(_ currentClick : UIButton) -> Bool {
        if let lastBtn = LastClieckedBtn, currentClick == lastBtn {
            lastBtn.isHighlighted = false
            lastBtn.layer.borderWidth = 0
            drawing.CurrentToolType = .Pinching
            LastClieckedBtn = nil
            EnableGestrueRecognizer()
            return true
        }
        return false
    }
    
    private func SwitchButtonHighlight(_ currentClick : UIButton) {
        LastClieckedBtn?.isHighlighted = false
        LastClieckedBtn?.layer.borderWidth = 0
        
        currentClick.isHighlighted = true
        currentClick.layer.borderWidth = 2.0
        currentClick.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // ----------- 工具栏点击响应函数 --------------
    
    @IBAction func HandleErase(_ sender: UIButton) {
        if BackToPinchMode(sender) {
            return
        }
        SwitchButtonHighlight(sender)
        drawing.CurrentToolType = .Eraser
        DisableGestureRecognizer()
        LastClieckedBtn = sender
    }
    
    @IBAction func HandleAnchor(_ sender: UIButton) {
        if BackToPinchMode(sender) {
            return
        }
        SwitchButtonHighlight(sender)
        drawing.CurrentToolType = .ColorAnchor
        DisableGestureRecognizer()
        LastClieckedBtn = sender
    }
    
    @IBAction func HandleColorHint(_ sender: UIButton) {
        if BackToPinchMode(sender) {
            return
        }
        SwitchButtonHighlight(sender)
        drawing.CurrentToolType = .ColorHint
        DisableGestureRecognizer()
        LastClieckedBtn = sender
    }
    
    private func SyncTwoCanvas() {
        background.frame = drawing.frame
        drawing.bounds = OriginBounds
        backgroundIv.bounds = OriginBounds
    }
    
    @IBAction func HandleEditing(_ sender: UIButton) {
        
        if !HadShownEditingTypeHint {
            ShowShouldNotUseDrawingModeAlert(sender)
            
        }
        else {
            ActualHandleEditing(sender)
        }
        
    }
    
    private func ActualHandleEditing(_ sender : UIButton) {
        if BackToPinchMode(sender) {
            return
        }
        SwitchButtonHighlight(sender)
        drawing.CurrentToolType = .Drawing
        DisableGestureRecognizer()
        LastClieckedBtn = sender
        SyncTwoCanvas()
    }
    @IBAction func HandleMultifuncButton(_ sender: UIButton) {
        ShowMultifunc()
    }
    // ---------- 连接颜色Picker和当前VC的相关函数 ----------------
    
    @IBAction func HandleOpenColorPicker(_ sender: UITapGestureRecognizer) {
        ShowPopover()
    }
    
    private func HandlePickColor(_ rgb : RGB) {
        PickedColor = rgb
        PickedColorIndicator.backgroundColor = rgb.AsUIColor
        drawing.SetPaintingLineColor(rgb)
    }
    private func HandlePickPenLineWidth(_ width : CGFloat) {
        drawing.SetPaintingLineWidth(width)
    }
    
    private func ShowShouldNotUseDrawingModeAlert(_ sender : UIButton) {
        let alerts = UIAlertController.MakeAlertDialog("即将进入绘图模式", "本软件是线稿上色软件，并非专业的画图软件。因此本软件对于绘图模式仅提供了有限的支持，与市面上常见的绘画软件相比有较大差距，不推荐您使用本软件的绘图模式开始您的创作。iAnime推荐使用Autodesk SketchBook软件完成您的创作后再将作品导入到本软件上色。是否仍然进入绘图模式？", [
                UIAlertAction(title: "前往Autodesk SketchBook下载", style: .default, handler: nil),
                UIAlertAction(title: "仍然进入绘图模式", style: .default, handler: {
                    _ in
                    self.ActualHandleEditing(sender)
                    self.HadShownEditingTypeHint = true
                }),
                UIAlertAction(title: "取消", style: .cancel, handler: nil)
            ])
        present(alerts, animated: true, completion: nil)
    }
    
    // ------------- 帮助类函数 ---------------
    
    private func HandleChangePenLineWidth(_ width : CGFloat) {
        drawing.SetPaintingLineWidth(width)
    }
    
    private func ShowPopover() {
        // 显示出调色板
        let storyboard = UIStoryboard(name: "Test", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TestColorPicker") as? TestViewController {
            vc.modalPresentationStyle = .popover
            vc.popoverPresentationController?.delegate = vc
            vc.popoverPresentationController?.sourceView = PickedColorIndicator
            vc.popoverPresentationController?.sourceRect = PickedColorIndicator.bounds
            vc.popoverPresentationController?.backgroundColor = vc.view.backgroundColor
            vc.preferredContentSize = CGSize(width: 320, height: 520)
            vc.GetPickerRectPosition(PickedColor)
            vc.OnPickedRGBColor = HandlePickColor(_:)
            vc.OnPenLineWidthChanged = HandlePickPenLineWidth(_:)
            vc.SetCurrentPenLineWidth(drawing.CurrentLineWidth)
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func ShowMultifunc() {
        if let sb = storyboard {
            if let MultiVC = sb.instantiateViewController(withIdentifier: "Multifunc") as? MultifuncViewController {
                MultiVC.modalPresentationStyle = .popover
                MultiVC.popoverPresentationController?.delegate = MultiVC
                MultiVC.popoverPresentationController?.sourceView = MultifuncBtn
                MultiVC.popoverPresentationController?.sourceRect = MultifuncBtn.bounds
                MultiVC.preferredContentSize = CGSize(width: 320, height: 520)
                // 告知列表状态
                
                
                present(MultiVC, animated: true, completion: nil)
            }
        }
    }
    
    private func ExportDrawingViewToImageFile() {
        UIGraphicsBeginImageContextWithOptions(drawing.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        
        UIGraphicsEndImageContext()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func DrawRoundCircile() {
        // 为上面的工具条画上淡淡的阴影 + 圆角
        
        Toolbar.layer.cornerRadius = 10
        Toolbar.backgroundColor = UIColor.white
       
        let linePath = UIBezierPath(roundedRect: CGRect(x: -2 , y: 6,
                                    width: Toolbar.bounds.width + 4,
                                    height: Toolbar.bounds.height + 2),
                                    byRoundingCorners: UIRectCorner(arrayLiteral: .bottomLeft,.bottomRight),
                                    cornerRadii: CGSize(width: 10, height: 10))
        
        Toolbar.layer.shadowPath = linePath.cgPath
        Toolbar.layer.shadowColor = UIColor.black.cgColor
        Toolbar.layer.shadowOpacity = 0.15
        Toolbar.layer.shadowOffset = CGSize(width: 0, height: 0)
        Toolbar.layer.shadowRadius = 15
        Toolbar.layer.masksToBounds = false
    }
}
