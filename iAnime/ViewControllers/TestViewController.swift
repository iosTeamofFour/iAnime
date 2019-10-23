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
        GetPickerRectPosition(RGB(R:41,G:31,B:177))
    }
    
    func GetPickerRectPosition(_ rgb : RGB) {
        let Ranked = rgb.RankedRGB()
        let yRate = 1 - Ranked[0].element / 255.0 // 通过最大分量立即可得yRate
        let xRate = 1 - Ranked[2].element / (Ranked[0].element)
        
        var RightEdgeRGB : [CGFloat] = [0,0,0]
        RightEdgeRGB[Ranked[0].offset] = Ranked[0].element
        RightEdgeRGB[Ranked[2].offset] = 0
        RightEdgeRGB[Ranked[1].offset] = CGFloat(Int((Ranked[1].element - (Ranked[0].element) * (1 - xRate))/xRate))
        
        var PickerBarRGB : [CGFloat] = [0,0,0]
        PickerBarRGB[Ranked[0].offset] = 255.0
        PickerBarRGB[Ranked[2].offset] = 0
        PickerBarRGB[Ranked[1].offset] = CGFloat(Int((RightEdgeRGB[Ranked[1].offset]) / (1 - yRate)))
        
        let targetRGB = RGB(R: PickerBarRGB[0],G:PickerBarRGB[1],B:PickerBarRGB[2])
        
        for i in 0...1530 {
            if targetRGB == ColorPickerBar.GetRGBFromN(i) {
                print(CGFloat(i) / 1530)
            }
        }
    }
}
