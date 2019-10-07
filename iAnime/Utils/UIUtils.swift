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
