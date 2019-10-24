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
    private var PickedColor = RGB(R:255,G:0,B:0)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DrawRoundCircile()
    }
    
    @IBAction func HandleReturn(_ sender: UIButton) {
        
    }
    
    @IBAction func HandleUndo(_ sender: UIButton) {
        
    }
    
    @IBAction func HandleRedo(_ sender: UIButton) {
        
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
    }
    
    private func ShowPopover() {
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
        
        Toolbar.layer.cornerRadius = 10
        Toolbar.backgroundColor = UIColor.white
        
        // 描边
       
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
