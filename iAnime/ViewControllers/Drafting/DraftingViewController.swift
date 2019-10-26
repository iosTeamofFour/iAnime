//
//  DraftingViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/23.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class DraftingViewController: UIViewController {

    @IBOutlet weak var Toolbar: UIView!
    @IBOutlet weak var PickedColorIndicator: RoundCornerUIImageView!
    private var PickedColor = RGB(R:0,G:0,B:0)
    
    // 主绘制区域
    @IBOutlet weak var drawing: DrawingView!
    
    
    // 工具条区域
    @IBOutlet weak var UndoBtn: UIButton!
    @IBOutlet weak var RedoBtn: UIButton!
    @IBOutlet weak var EraserBtn: UIButton!
    @IBOutlet weak var ColorAnchorBtn: UIButton!
    @IBOutlet weak var ColorHintBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawing.draftingController = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DrawRoundCircile()
    }
    
    @IBAction func HandleReturn(_ sender: UIButton) {
        
    }
    

    
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
    
    @IBAction func HandleErase(_ sender: Any) {
        
    }
    
    @IBAction func HandleAnchor(_ sender: UIButton) {
    }
    
    
    @IBAction func HandleColorHint(_ sender: Any) {
        
    }
    
    @IBAction func HandleUpload(_ sender: UIButton) {
        
    }
    
    @IBAction func HandleOpenColorPicker(_ sender: UITapGestureRecognizer) {
        ShowPopover()
    }
    
    private func HandlePickColor(_ rgb : RGB) {
        PickedColor = rgb
        PickedColorIndicator.backgroundColor = rgb.AsUIColor
        drawing.SetPaintingLineColor(rgb)
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
            vc.preferredContentSize = CGSize(width: 320, height: 460)
            vc.GetPickerRectPosition(PickedColor)
            vc.OnPickedRGBColor = HandlePickColor(_:)
            present(vc, animated: true, completion: nil)
        }
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
