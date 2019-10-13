//
//  UIUtils.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit

class UIUtils {
    
    public static func GetScreenWHPixel() -> (CGFloat, CGFloat) {
        let ScreenScale = UIScreen.main.scale
        let (DPWidth, DPHeight) = GetScreenWHDP()
        return (DPWidth * ScreenScale, DPHeight * ScreenScale)
    }
    
    public static func GetScreenWHDP() -> (CGFloat, CGFloat) {
        let ScreenSize = UIScreen.main.bounds.size
        return (ScreenSize.width, ScreenSize.height)
    }
    
    static var ScreenScale : CGFloat {
        get {
            return UIScreen.main.scale
        }
    }
    
    
    public static func DetectStatusBarColor(_ view : UIView, _ backgroundImageView : UIImageView) -> Bool {
        let safeAreaHeight = Int(20)
        let safeAreaWidth = Int(view.frame.width)
        var points : [CGPoint] = []
        for i in 0..<safeAreaHeight {
            for j in 0..<safeAreaWidth {
                points.append(CGPoint(x: j, y: i))
            }
        }
        
        let colors = backgroundImageView.PixelOfRawImage(at: points)
        let rgb = CalcRGBAvg(colors!)
        
        return (rgb[0] + rgb[1] + rgb[2]) < 1.3
    }
    
    public static func DetectTextColorWithBG(_ viewWithText : UIView, _ backgroundView : UIImageView) -> Bool {
        
        let rect = viewWithText.convert(viewWithText.bounds, to: backgroundView)
        var points : [CGPoint] = []
        let minX = Int(rect.minX), minY = Int(rect.minY), maxX = Int(rect.maxX), maxY = Int(rect.maxY)
        for i in minY..<maxY {
            for j in minX..<maxX {
                points.append(CGPoint(x: j, y: i))
            }
        }
        
        let colors = backgroundView.PixelOfRawImage(at: points)
        let rgb = CalcRGBAvg(colors!)
        return (rgb[0] + rgb[1] + rgb[2]) < 1.3
    }
    
    public static func CalcRGBAvg(_ colors: [[CGFloat]]) -> [CGFloat] {
        var r : CGFloat = 0, g : CGFloat = 0, b : CGFloat = 0
        colors.forEach{ c in
            r += c[0]
            g += c[1]
            b += c[2]
        }
        r /= CGFloat(colors.count)
        g /= CGFloat(colors.count)
        b /= CGFloat(colors.count)
        return [r,g,b]
    }
}

public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    public func SubviewsContentSize() -> CGRect {
        return subviews.map { v in v.frame }.reduce(CGRect.zero, { a, b in a.union(b)} )
    }
    
    public func ConvertPointToWindowCoord(_ point: CGPoint) -> CGPoint {
        let window = UIApplication.shared.delegate?.window!
        let coord =  convert(point, to: window)
        return coord
    }
}

public extension UIStackView {
    public func AddBackgroundColor(_  color : UIColor) {
        let view = UIView()
        view.backgroundColor = color
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(view, at: 0)
        view.pin(to: self)
        
    }
    
    public func AddBackgroundView(_ view :UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(view, at: 0)
        view.pin(to: self)
    }
    
    public func StackViewSubviewsContentSize() -> CGRect {
        return arrangedSubviews.map { v in v.frame }.reduce(CGRect.zero, { a, b in a.union(b)} )
    }
}

public extension UITextField {
    public func ChangeBorder(_ borderStyle : BorderStyle, _ cornerRadius : CGFloat, _ borderColor : CGColor, _ borderWidth : CGFloat ) {
        self.borderStyle = borderStyle
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
    
    public func ChangePlaceHolderTextColor( _ color : CGColor) {
         self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

public extension Array {
    public func InRange(_ index : Int) -> Bool {
        return 0 <= index && index < self.count
    }
}

public extension UIImageView {
    public func SetCircleBorder() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }
    
//    public func PixelColorAt(_ point : CGPoint) -> [CGFloat] {
//        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
//
//        context!.translateBy(x: -point.x, y: -point.y)
//        layer.render(in: context!)
//        let result = [CGFloat(pixel[0])/255.0, CGFloat(pixel[1])/255.0, CGFloat(pixel[2])/255.0]
//        pixel.deallocate()
//        return result
//    }
    
    public func PixelOfRawImage(at: [CGPoint]) -> [[CGFloat]]? {
        
//        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
//
//        var results : [[CGFloat]] = []
//
//        for point in at {
//            context!.translateBy(x: -point.x, y: -point.y)
//            layer.render(in: context!)
//            let result = [CGFloat(pixel[0])/255.0, CGFloat(pixel[1])/255.0, CGFloat(pixel[2])/255.0]
//            context!.translateBy(x: point.x, y: point.y)
//            results.append(result)
//        }
//
//        pixel.deallocate()
//        return results
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * Int(bounds.width)
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: Int(bounds.width), height: Int(bounds.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return nil
        }
        layer.render(in: context)
        return at.map( {
            px in
            let index = bytesPerRow + Int(px.y) + bytesPerPixel * Int(px.x)
            return [CGFloat(ptr[index]), CGFloat(ptr[index+1]), CGFloat(ptr[index+2])]
        })
        
    }
}

public extension UIButton {
    public func AddCircleShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}

public extension NSLayoutConstraint {
    public func Activate() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
}
