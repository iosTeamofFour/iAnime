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
    
    @IBOutlet weak var ColorPickerBar: ColorPickerBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ColorPickerBar.OnPickedColorBar = {
            (rgb,pos) in
            self.ColorPickerRect.BeginRGB = rgb
        }
        
        ColorPickerRect.OnPickedColorRect = {
            (rgb, pos) in
        }
    }
}
