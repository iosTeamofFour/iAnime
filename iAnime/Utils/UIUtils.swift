//
//  UIUtils.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
        let rect = CGRect(x: 0, y: 0, width: safeAreaWidth, height: safeAreaHeight)
        let result = GetRectAvgRGB(rect,backgroundImageView)
        return (result[0] + result[1] + result[2]) < 1.3
    }
    
    public static func DetectTextColorWithBG(_ viewWithText : UIView, _ backgroundView : UIImageView) -> Bool {
        
        let rect = viewWithText.convert(viewWithText.bounds, to: backgroundView)
        let result = GetRectAvgRGB(rect,backgroundView)
        
        return (result[0] + result[1] + result[2]) < 1.3
    }
    
    private static func GetRectAvgRGB(_ rect : CGRect, _ imageView : UIImageView) -> [CGFloat] {
        var points : [CGPoint] = []
        let minX = Int(rect.minX), minY = Int(rect.minY), maxX = Int(rect.maxX), maxY = Int(rect.maxY)
        for i in minY..<maxY {
            for j in minX..<maxX {
                points.append(CGPoint(x: j, y: i))
            }
        }
        
        let pixels = imageView.pixels ?? []
        
        let colors = points.map({
            p -> [CGFloat] in
            let pixelIndex = imageView.pixelIndex(for: p) ?? 0
            let pixelColor = pixels[pixelIndex]
            let rgb = imageView.extraColor(for: pixelColor)
            return [CGFloat(rgb[0]), CGFloat(rgb[1]), CGFloat(rgb[2])]
        })
        // 此时传出来的RGB是0-255区间的，需要在AVG函数中除以255.0
        let result = CalcRGBAvg(colors)
        return result
    }
    
    public static func CalcRGBAvg(_ colors: [[CGFloat]]) -> [CGFloat] {
        var r : CGFloat = 0, g : CGFloat = 0, b : CGFloat = 0
        colors.forEach{ c in
            r += c[0] / 255.0
            g += c[1] / 255.0
            b += c[2] / 255.0
        }
        r /= CGFloat(colors.count)
        g /= CGFloat(colors.count)
        b /= CGFloat(colors.count)
        return [r,g,b]
    }
}

public extension UIImage {
    
    
    public func Resize(_ NewSize : CGSize) -> UIImage {
        var newSize = NewSize
        let CurrWidth = self.size.width
        let CurrHeight = self.size.height
        
        let CurrRatio = CurrWidth / CurrHeight
        
        if CurrRatio < 1 {
            newSize.height = NewSize.width / CurrRatio
        }
        else {
            newSize.width = NewSize.height * CurrRatio
        }
        
        UIGraphicsBeginImageContext(NewSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    

    
    public func extraPixels(in size: CGSize) -> [UInt32]? {
        
        guard let cgImage = cgImage else {
            return nil
        }
        // 这里传进来的size是imageview的bounds
        
        let width = Int(size.width)
        let height = Int(size.height)
        
        // 一个像素 4 个字节，则一行共 4 * width 个字节
        let bytesPerRow = 4 * width
        // 每个像素元素位数为 8 bit，即 rgba 每位各 1 个字节
        let bitsPerComponent = 8
        // 颜色空间为 RGB，这决定了输出颜色的编码是 RGB 还是其他（比如 YUV）
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 设置位图颜色分布为 RGBA
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        var pixelsData = [UInt32](repeatElement(0, count: width * height))
        guard let content = CGContext(data: &pixelsData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        // 在这里完成真实长宽到bounds的映射。
        content.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelsData
    }
}


public extension UIView {
    public func pin(to view: UIView) {
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            topAnchor.constraint(equalTo: view.topAnchor),
//            bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])
        
        self.snp.makeConstraints {
            make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
        
    }
    
    public func SubviewsContentSize() -> CGRect {
        return subviews.map { v in v.frame }.reduce(CGRect.zero, { a, b in a.union(b)} )
    }
    
    public func ConvertPointToWindowCoord(_ point: CGPoint) -> CGPoint {
        let window = UIApplication.shared.delegate?.window!
        let coord =  convert(point, to: window)
        return coord
    }
    
    public func PointInside(_ point : CGPoint ) -> Bool {
        return bounds.contains(point)
    }
    
    public func ShowLoadingIndicator() -> (UIView,UIActivityIndicatorView) {
        let uiView = self
        let container = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        let loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0.0, y:0.0, width: 40.0,height: 40.0);
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x:loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
        return (container, actInd)
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
    // 获取UIImageView中的全部像素值
    public var pixels: [UInt32]? {
        return image?.extraPixels(in: bounds.size)
    }
    
    /// 将位置转换为像素索引
    ///
    /// - parameter point: 位置
    ///
    /// - returns: 像素索引
    public func pixelIndex(for point: CGPoint) -> Int? {
        let size = bounds.size
        guard point.x > 0 && point.x <= size.width
            && point.y > 0 && point.y <= size.height else {
                return nil
        }
        return (Int(point.y) * Int(size.width) + Int(point.x))
    }
    
    /// 将像素值转换为颜色
    ///
    /// - parameter pixel: 像素值
    ///
    /// - returns: 颜色
    public func extraColor(for pixel: UInt32) -> [Int] {
        let r = Int((pixel >> 0) & 0xff)
        let g = Int((pixel >> 8) & 0xff)
        let b = Int((pixel >> 16) & 0xff)
//        let a = Int((pixel >> 24) & 0xff)
        return [r,g,b]
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
