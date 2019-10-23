//
//  ColorPickerBarView.swift
//  iAnime
//
//  Created by Zoom on 2019/10/23.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit

class ColorPickerBarView: UIView {

    var OnPickedColorBar : ((RGB, CGPoint)->Void)?
    
    private(set) var indicator : UIView!
    
    private(set) var CurrentYRate : CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        InitPickerBar()
        InitSelectIndicator()
    }
    
    private func InitPickerBar() {
        let gradients = CAGradientLayer()
        gradients.frame = bounds
        layer.addSublayer(gradients)
        
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
    
    private func InitSelectIndicator() {
        
        indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isUserInteractionEnabled = false
        addSubview(indicator)
        let barWidth = frame.width
        
        indicator.snp.makeConstraints {
            make in
            make.width.equalTo(barWidth)
            make.height.equalTo(indicator.snp.width)
        }

        let path = UIBezierPath(arcCenter: CGPoint(x: barWidth/2, y: barWidth/2), radius: barWidth/2-2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let layer = CAShapeLayer(layer: indicator.layer)
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        indicator.transform = indicator.transform.translatedBy(x: 0, y: -barWidth/2)
        indicator.layer.addSublayer(layer)
    }

    func MoveIndicatorToPosition(_ yRate : CGFloat, _ firePickColor : Bool = false) {
        MoveIndicatorFrameToPosition(yRate)
        if firePickColor {
            HandlePickColor(CGPoint(x: 0, y: yRate * bounds.height))
        }
    }
    private func MoveIndicatorFrameToPosition(_ yRate : CGFloat) {
        CurrentYRate = yRate
        indicator.frame.origin.y = yRate * frame.height - (frame.width)/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touched = touches.first!.location(in: self)
        if PointInside(touched) {
            HandlePickColor(touched)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touched = touches.first!.location(in: self)
        if PointInside(touched) {
            HandlePickColor(touched)
        }
    }
    func GetRGBFromN(_ n : Int) -> RGB {
        let rangeIndex = n / 255
        var R = 0, G = 0, B = 0
        switch rangeIndex {
        case 0:
            R = 255
            G = 0
            B = n % 255
            break
        case 1:
            R = 255 - n % 255
            G = 0
            B = 255
            break
        case 2:
            R = 0
            G = n % 255
            B = 255
            break
        case 3:
            R = 0
            G = 255
            B = 255 - n % 255
            break
        case 4:
            R = n % 255
            G = 255
            B = 0
            break
        case 5:
            R = 255
            G = 255 - n % 255
            B = 0
            break
        case 6:
            R = 255
            G = 0
            B = 0
            break
        default:
            break
        }
        let rgb = RGB(R: CGFloat(R), G: CGFloat(G), B: CGFloat(B))
        return rgb
    }
    private func HandlePickColor(_ position : CGPoint) {
        let yRate = position.y / bounds.height
        let n = Int(1530 * yRate)
        let rgb = GetRGBFromN(n)
        MoveIndicatorFrameToPosition(yRate)
        OnPickedColorBar?(rgb,position)
    }
}
