//
//  TestViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var ColorPickerRect: ColorPickerRectView!
    
    @IBOutlet weak var ColorPickerBar: ColorPickerBarView!
    
    @IBOutlet weak var RValue: UILabel!
    @IBOutlet weak var GValue: UILabel!
    @IBOutlet weak var BValue: UILabel!
    
    @IBOutlet weak var RSlider: UISlider!
    @IBOutlet weak var GSlider: UISlider!
    @IBOutlet weak var BSlider: UISlider!
    
    @IBOutlet weak var CurrentColor: RoundCornerUIImageView!
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ColorPickerBar.OnPickedColorBar = {
            (rgb,pos) in
            self.ColorPickerRect.BeginRGB = rgb
            self.ColorPickerRect.ShouldPickColor()
            
        }
        
        ColorPickerRect.OnPickedColorRect = {
            (rgb, pos) in
            self.UpdateSliderAndTextIndicator(rgb)
        }
        RSlider.addTarget(self, action: #selector(OnSliderValueChanged), for: .valueChanged)
        GSlider.addTarget(self, action: #selector(OnSliderValueChanged), for: .valueChanged)
        BSlider.addTarget(self, action: #selector(OnSliderValueChanged), for: .valueChanged)
//        GetPickerRectPosition(RGB(R:41,G:31,B:177))
    }
    
    private func UpdateSliderAndTextIndicator(_ rgb : RGB) {
        self.RValue.text = String(Int(rgb.R))
        self.GValue.text = String(Int(rgb.G))
        self.BValue.text = String(Int(rgb.B))
        self.RSlider.value = Float(rgb.R)
        self.GSlider.value = Float(rgb.G)
        self.BSlider.value = Float(rgb.B)
        self.CurrentColor.backgroundColor = rgb.AsUIColor
    }
    
    func GetPickerRectPosition(_ rgb : RGB) {
        UpdateSliderAndTextIndicator(rgb)
        
        let Ranked = rgb.RankedRGB()
        
        if Ranked[0].element == 0 {
            ColorPickerRect.MoveIndicatorToPosition(0, 1)
            return
        }
        
        let yRate = 1 - Ranked[0].element / 255.0 // 通过最大分量立即可得yRate
        let xRate = 1 - Ranked[2].element / (Ranked[0].element)
        
        if xRate == 0 {
            ColorPickerRect.MoveIndicatorToPosition(xRate, yRate)
            return
        }
        
        var RightEdgeRGB : [CGFloat] = [0,0,0]
        RightEdgeRGB[Ranked[0].offset] = Ranked[0].element
        RightEdgeRGB[Ranked[2].offset] = 0
        RightEdgeRGB[Ranked[1].offset] = CGFloat(Int((Ranked[1].element - (Ranked[0].element) * (1 - xRate))/xRate))
        
        var PickerBarRGB : [CGFloat] = [0,0,0]
        PickerBarRGB[Ranked[0].offset] = 255.0
        PickerBarRGB[Ranked[2].offset] = 0
        PickerBarRGB[Ranked[1].offset] = CGFloat(Int((RightEdgeRGB[Ranked[1].offset]) / (1 - yRate)))
        
        ColorPickerRect.MoveIndicatorToPosition(xRate, yRate)
        ColorPickerRect.BeginRGB = RGB(R:PickerBarRGB[0],G:PickerBarRGB[1],B:PickerBarRGB[2])
        
        let targetRGB = RGB(R: PickerBarRGB[0],G:PickerBarRGB[1],B:PickerBarRGB[2])
        
        var yBarRate : CGFloat = 0
        for i in 0...1530 {
            if targetRGB == ColorPickerBar.GetRGBFromN(i) {
                yBarRate = CGFloat(i) / 1530.0
            }
        }
        ColorPickerBar.MoveIndicatorToPosition(yBarRate)
    }
    
    @objc private func OnSliderValueChanged(_ sender: UISlider) {
        let r = CGFloat(RSlider.value)
        let g = CGFloat(GSlider.value)
        let b = CGFloat(BSlider.value)
        let rgb = RGB(R:r,G:g,B:b)
        GetPickerRectPosition(rgb)
    }
}
