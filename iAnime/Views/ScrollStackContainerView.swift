//
//  ScrollStackContainerView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

@IBDesignable
class ScrollStackContainerView: UIView {
    @IBInspectable var spacingWidth : CGFloat = 8
    @IBInspectable var spacingEachImage : CGFloat = 8
    
    public var StackViews : [UIStackView] = []
    public var OnPlacedStackView : (([UIStackView]) -> Void)?
    public var EachStackViewWidth : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if StackViews.count == 0  {
            PlaceThreeScrollStackView()
        }
    }
    
    private func PlaceThreeScrollStackView() {
        let (ScreenWidth, _) = UIUtils.GetScreenWHDP()
        EachStackViewWidth = (ScreenWidth - spacingWidth * 4) / 3
        
        for i in 0..<3 {
            let x = CGFloat(Int(self.spacingWidth) * (1 + i) + Int(EachStackViewWidth) * i)
            
//            let y = self.safeAreaInsets.top
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.spacing = spacingEachImage
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .fill
            stackView.alignment = .fill
            StackViews.append(stackView)
            self.addSubview(stackView)
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: x).isActive = true
            
            
        }
        OnPlacedStackView?(StackViews)
    }
}
