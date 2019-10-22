//
//  TestViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var ColorPickerRect: ColorPickerRectView!
    
    @IBOutlet weak var RValue: UITextField!
    @IBOutlet weak var GValue: UITextField!
    @IBOutlet weak var BValue: UITextField!
    
    
    @IBOutlet weak var ColorPickerBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ColorPickerImage.image = UIImage(named: "ColorPickerBackground")
        InitColorPickerBar()
    }
    
    @IBAction func DynamicChangePanel(_ sender: UIButton) {
        let r = CGFloat(Int(RValue.text!)!)
        let g = CGFloat(Int(GValue.text!)!)
        let b = CGFloat(Int(BValue.text!)!)
        let rgb = RGB(R:r,G:g,B:b)
        
//        ColorPickerRect.BeginRGB = rgb
        
    }
    
    
    private func InitColorPickerBar() {

        let gradients = CAGradientLayer()
        gradients.frame = ColorPickerBar.bounds
        ColorPickerBar.layer.addSublayer(gradients)
        
        gradients.colors = [UIColor.red.cgColor,
                            UIColor.magenta.cgColor,
                            UIColor.blue.cgColor,
                            UIColor.cyan.cgColor,
                            UIColor.green.cgColor,
                            UIColor.yellow.cgColor,
                            UIColor.red.cgColor]
        gradients.startPoint = CGPoint(x: 0.5, y: 0)
        gradients.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
