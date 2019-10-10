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
    
    
    public static func DetectStatusBarColor(_ view : UIView, _ backgroundImageView : UIImageView) -> Bool {
        let safeAreaHeight = Int(view.safeAreaInsets.top)
        let safeAreaWidth = Int(view.frame.width)
        var points : [CGPoint] = []
        let pointCount = Int(safeAreaWidth) * Int(safeAreaHeight)
        for i in 0..<safeAreaHeight {
            for j in 0..<safeAreaWidth {
                points.append(CGPoint(x: j, y: i))
            }
        }
        
        let colors = backgroundImageView.image?.cgImage?.colors(at: points)
        var r : CGFloat = 0, g : CGFloat = 0, b : CGFloat = 0
        colors?.forEach{ c in
            r += c[0]
            g += c[1]
            b += c[2]
        }
        r /= CGFloat(pointCount)
        g /= CGFloat(pointCount)
        b /= CGFloat(pointCount)
        
        print("\(r)  \(g)  \(b)")
        
        return (r + g + b) < 1
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

public extension CGImage {
    func colors(at: [CGPoint]) -> [[CGFloat]]? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return nil
        }
        
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return at.map { p in
            let i = bytesPerRow * Int(p.y) + bytesPerPixel * Int(p.x)
            
            let a = CGFloat(ptr[i + 3]) / 255.0
            let r = (CGFloat(ptr[i]) / a) / 255.0
            let g = (CGFloat(ptr[i + 1]) / a) / 255.0
            let b = (CGFloat(ptr[i + 2]) / a) / 255.0
            
            return [r,g,b,a]
        }
    }
}

public extension NSLayoutConstraint {
    public func Activate() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
}
