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
    
    var shouldRestoreData : DraftData?
    var drawingInfo : DrawingInfo?
    
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
        
        if shouldRestoreData != nil {
            // 在此进行现场恢复工作
            ProcessRestoreDrawingView()
        }
        else {
            ProcessCreateNewDrawingView()
        }
        
        OriginBounds = CGRect(x: 0, y: 0, width: drawing.bounds.width, height: drawing.bounds.height)
        AttachGestureRecognizerToImageView(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DrawRoundCircile()
    }
    
    // 执行创建新绘图工作区域的必要流程
    
    private func ProcessCreateNewDrawingView() {
        background.image = shouldLoadBackground
        drawingInfo = DrawingInfo(DrawingID: UUID().uuidString, Name: "新建绘画", Description: "暂无描述", Tags: [], AllowSaveToLocal: true, AllowFork: true, CreatedTime: Date2Unix(Date()))
    }
    
    // 将草稿数据重新还原到画板上面
    private func ProcessRestoreDrawingView() {
        let data = shouldRestoreData!
        background.image = data.Background
        drawing.image = data.Foreground
        drawing.ReplayDrawingHistories(data.Lines)
        
        if data.Lines.count > 0 {
            NotifyCanUndo()
        }
        // 从本地文件加载的记录，不应该启动Redo
        NofityCanNotRedo()
        for anchor in data.Anchors {
            drawing.DrawColorPoint(anchor.vector.AsCGPoint(), .Anchor, anchor.anchor.color)
        }
        
        for hint in data.Hints {
            drawing.DrawColorPoint(hint.vector.AsCGPoint(), .Hint, hint.hint.color)
        }
    }
    
    // ========= 界面逻辑功能函数 ============
    
    @IBAction func HandleReturn(_ sender: UIButton) {
        if drawing.image != nil {
            // 探测一下是否需要保存草稿
            AskIfPersistDraft()
        }
        else {
            ActualReturn()
        }
    }
    
    private func ActualReturn() {
        
        // 释放内存, 避免读大图时内存泄漏
        
        background.removeFromSuperview()
        drawing.removeFromSuperview()
        
        background = nil
        drawing = nil
        
        
        if let naviController = navigationController {
            naviController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func AskIfPersistDraft() {
        let alertController = UIAlertController.MakeAlertDialog("是否保存草稿", nil, [
            UIAlertAction(title: "好", style: .default, handler: { _ in
                self.ExportDraftingData()
                self.ActualReturn()
            }),
            UIAlertAction(title: "取消", style: .cancel, handler: {
                _ in
                self.ActualReturn()
            })
            ])
        present(alertController, animated: true, completion:nil)
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
        HandleUsingTools(sender, .Eraser)
    }
    
    @IBAction func HandleAnchor(_ sender: UIButton) {
        HandleUsingTools(sender, .ColorAnchor)
    }
    
    @IBAction func HandleColorHint(_ sender: UIButton) {
        HandleUsingTools(sender, .ColorHint)
    }
    
    private func HandleUsingTools(_ sender: UIButton, _ toolType : UsingToolType) {
        if BackToPinchMode(sender) {
            return
        }
        SwitchButtonHighlight(sender)
        drawing.CurrentToolType = toolType
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
    
    
    
    // ------------- 进入额外功能Popover的触发函数 ---------------
    
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
        if let sb = storyboard, let MultiVC = sb.instantiateViewController(withIdentifier: "Multifunc") as? MultifuncViewController {
            
            MultiVC.modalPresentationStyle = .popover
            MultiVC.popoverPresentationController?.delegate = MultiVC
            MultiVC.popoverPresentationController?.sourceView = MultifuncBtn
            MultiVC.popoverPresentationController?.sourceRect = MultifuncBtn.bounds
            MultiVC.preferredContentSize = CGSize(width: 320, height: 520)
            MultiVC.drawingInfo = drawingInfo
            MultiVC.draftData = CollectDraftData()
            // 告知列表状态
            
            present(MultiVC, animated: true, completion: nil)
        }
    }
    
    // ========= 持久化相关函数 ==========
    
    // 将当前画板导出到文件
    func ExportDrawingViewToImageFile() -> Data? {
        UIGraphicsBeginImageContextWithOptions(drawing.bounds.size,false,0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(drawing.bounds)
        
        if background.image != nil {
            let imageSize = background.GetCGSizeInAspectFit(drawing.bounds.size)!
            
            let imageRect = CGRect(x: 0, y: (drawing.bounds.height-imageSize.height)/2, width: imageSize.width, height: imageSize.height)
            background.image?.draw(in: imageRect)
        }
        
        drawing.image?.draw(in: drawing.bounds)
        
        let driedSketch = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return driedSketch?.pngData()
        
//        var persistUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        persistUrl.appendPathComponent("draft.png")
//
//        print(persistUrl.absoluteString)
//        do {
//            try pngResult?.write(to: persistUrl)
//            print("成功写入")
//        }
//        catch  {
//            print("写入失败")
//        }
    }
    
    // 将当前画板导出到草稿
    
    func CollectDraftData() -> DraftData? {
        let bgImg = background.image
        guard let foreImg = drawing.image else {
            return nil
        }
        let lines = drawing.histories
        let anchors = ColorAnchorPair.ConvertDicToPair(drawing.anchors)
        let hints = ColorHintPair.ConvertDicToPair(drawing.hints)
        
        let draftData = DraftData(background: bgImg, foreground: foreImg, lines: lines, anchors: anchors, hints: hints)
        
        return draftData
    }
    
    func ExportDraftingData() {
        // Collecting drafting data...
//        if let draftData = CollectDraftData() {
//            let persisted = PersistenceManager.PersistDraftData(draftData)
//            if persisted {
//                print("已成功保存草稿.")
//                return
//            }
//        }
//        print("草稿保存失败.")
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ========== 界面美化的绘图相关函数 =============
    
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
