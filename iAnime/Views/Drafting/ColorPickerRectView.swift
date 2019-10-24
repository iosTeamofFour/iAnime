//
//  ColorPickerRectView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/22.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit
class ColorPickerRectView: UIView {
    
    var imageView : UIImageView!
    var OnPickedColorRect : ((RGB,CGPoint) -> Void)?
    var indicator : UIView!
    var indicatorSize : CGFloat = 25
    
    var CurrentPickedPosition = CGPoint.zero
    
    var BeginRGB : RGB! = RGB(R:255.0,G:0,B:0) {
        didSet {
            imageView.backgroundColor = BeginRGB.AsUIColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        CurrentPickedPosition = CGPoint(x: frame.width, y: 0)
        InitColorPickerImage()
        InitPickerIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        CurrentPickedPosition = CGPoint(x: frame.width, y: 0)
        InitColorPickerImage()
        InitPickerIndicator()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        MoveFrameToPosition(CurrentPickedPosition)
    }
    private func InitPickerIndicator() {
        indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isUserInteractionEnabled = false
        addSubview(indicator)
        
        indicator.snp.makeConstraints {
            make in
            make.width.equalTo(indicatorSize)
            make.height.equalTo(indicator.snp.width)
        }
        
        let path = UIBezierPath(arcCenter: CGPoint(x: indicatorSize/2, y: indicatorSize/2), radius: indicatorSize/2 - 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        
        
        let shape = CAShapeLayer(layer: indicator.layer)
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 2
        indicator.transform = indicator.transform.translatedBy(x: frame.width - indicatorSize/2, y: -indicatorSize/2)
        indicator.layer.addSublayer(shape)
    }
    
    func MoveIndicatorToPosition(_ xRate: CGFloat, _ yRate : CGFloat,_ firePickColor : Bool = false) {
        let PickedPoint = CGPoint(x: bounds.width * xRate, y: bounds.height * yRate)
        MoveFrameToPosition(PickedPoint)
        CurrentPickedPosition = PickedPoint
        
        if firePickColor {
            HandlePickColor(PickedPoint)
        }
    }
    
    private func MoveFrameToPosition(_ PickPoint : CGPoint) {
        indicator.frame.origin.x = PickPoint.x - indicatorSize/2
        indicator.frame.origin.y = PickPoint.y - indicatorSize/2
    }
    
    private func InitColorPickerImage() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ColorPickerBackground")!
        addSubview(imageView)
        imageView.snp.makeConstraints {
            make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        imageView.backgroundColor = BeginRGB.AsUIColor
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
    
    func ShouldPickColor() {
        HandlePickColor(CurrentPickedPosition)
    }

    private func HandlePickColor(_ PickPoint : CGPoint) {
        CurrentPickedPosition = PickPoint
        
        let xRate = PickPoint.x / bounds.width
        let yRate = PickPoint.y / bounds.height
        
        let LeftEdge = [255.0 * (1 - yRate), 255.0 * (1 - yRate), 255.0 * (1 - yRate)]
        let RightEdge = BeginRGB.ArrayShape.map { value in value * (1 - yRate) }
        
        let PickedR = LeftEdge[0] - xRate * (LeftEdge[0] - RightEdge[0])
        let PickedG = LeftEdge[1] - xRate * (LeftEdge[1] - RightEdge[1])
        let PickedB = LeftEdge[2] - xRate * (LeftEdge[2] - RightEdge[2])
        
        let PickedRGB = RGB(R: PickedR, G: PickedG, B: PickedB)
        MoveFrameToPosition(PickPoint)
        OnPickedColorRect?(PickedRGB,PickPoint)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 下面这段代码很难写，但是写出来之后发现执行效率太低了，遂弃用之。不过舍不得删掉，还是留在这里。
        
        
//        var sortedRGB = BeginRGB.RankedRGB()
//        let LargeDecrementStep = sortedRGB[0].element / 255.0
//        let MiddleDecrementStep = sortedRGB[1].element / 255.0
//        let scaled = (frame.width-1) / 255.0
//        for j in 0...255 {
//            // Outside for-loop is to deal with height-side decrement.
//            var currentRGBArr = BeginRGB.ArrayShape
//            currentRGBArr[sortedRGB[0].offset] -= LargeDecrementStep * CGFloat(j)
//            currentRGBArr[sortedRGB[1].offset] -= MiddleDecrementStep * CGFloat(j)
//
//            let lineRGB = RGB(R: currentRGBArr[0], G: currentRGBArr[1], B: currentRGBArr[2])
//            var lineRGBRanked = lineRGB.RankedRGB()
//
//            let SmallIncrementStep = lineRGBRanked[0].element / 255.0
//            let MiddleIncrementStep = (lineRGBRanked[0].element - lineRGBRanked[1].element) / 255.0
//
//            for i in (0...255).reversed() {
//                // Inside for-loop is to deal with width-side increment.
//                var lineRGBArr = lineRGB.ArrayShape
//                lineRGBArr[lineRGBRanked[2].offset] += SmallIncrementStep * CGFloat(255-i)
//                lineRGBArr[lineRGBRanked[1].offset] += MiddleIncrementStep * CGFloat(255-i)
//                DrawSinglePixelPoint(CGRect(x: CGFloat(i) * scaled, y: CGFloat(j) * scaled, width: 1, height: 1), UIColor(red: lineRGBArr[0]/255.0, green: lineRGBArr[1]/255.0, blue: lineRGBArr[2]/255.0, alpha: 1))
//            }
//        }
    }
//
//    private func DrawSinglePixelPoint(_ position : CGRect, _ color: UIColor) {
//        let path = UIBezierPath(rect: position)
//        path.lineWidth = 0
//        color.setFill()
//        path.fill()
//    }
}
