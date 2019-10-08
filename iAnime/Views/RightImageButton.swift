//
//  RightImageButton.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//
import UIKit

@IBDesignable
class RightImageButton: UIButton {
    
    @IBInspectable var imagePaddingRight : CGFloat = 16.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imagePaddingRight).isActive = true
        self.imageView?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: 0.08) : UIColor.white
        }
    }
}
