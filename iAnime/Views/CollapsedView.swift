//
//  CollapsedView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class CollapsedView: UIView {

    @IBInspectable var arrowResourceName : String = "ArrowDown"
    @IBInspectable var labelPaddingLeft : CGFloat = 0
    @IBInspectable var labelPaddingTop : CGFloat = 4.0
    @IBInspectable var buttonPaddingLabelLeft : CGFloat = 4.0
    
    @IBInspectable var ViewName : String = ""
    @IBInspectable var ButtonImageWidth : CGFloat = 30
    
    var IsExpanded = false {
        didSet {
            if oldValue != IsExpanded {
                ToggleExpandAndCollapsed()
                OnExpandedToggled?(IsExpanded,self)
            }
        }
    }
    private(set) var label : UILabel!
    private(set) var button : UIButton!
    
    var OnExpandedToggled : ((Bool, CollapsedView) -> Void)?
    
    
    convenience init(_ Name : String) {
        self.init(frame: CGRect.zero)
        ViewName = Name
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if label == nil {
            LayoutCollapseHeader()
            
            // 因为引入的是一张向上的图，而默认是折叠，所以先把这张图旋转180°
            button.transform = button.transform.rotated(by: CGFloat.pi)
        }
    }
    
    
    private func LayoutCollapseHeader() {
        // Layout toggle expand/collapsed switch and title label.
        print("Begin to layout collapse header.")
        label = UILabel()
        button = UIButton(type: .custom)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = ViewName
        label.font = label.font.withSize(20)
        let img = UIImage(named: arrowResourceName)
        button.setImage(img, for: .normal)
        addSubview(label)
        addSubview(button)
        // 摆正Label的位置，约束当前Label距离外层View左边和上面的间隔
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelPaddingLeft).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: labelPaddingTop).isActive = true
        
        button.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4).isActive = true
        button.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: ButtonImageWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: ButtonImageWidth).isActive = true
        
        // 计算当前内容大小
        let subv = [label, button]
        subv.forEach { v in v?.layoutIfNeeded() }
        let size = subv.map({ v in v!.frame }).reduce(CGRect.zero, { a, b in a.union(b)})
        let totalWidth = subv.map({ v in v!.frame }).reduce(0, { a, b in a + b.width }) + 10
        
        widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.addTarget(self, action: #selector(InnerButtonClickHandler), for: .touchUpInside)
    }
    
    @objc func InnerButtonClickHandler(sender: UIButton!) {
        IsExpanded = !IsExpanded
    }
    
    private func ToggleExpandAndCollapsed() {
        print("当前页面展开情况: \(IsExpanded)")
        RotateExpandArrow()
    }
    
    private func RotateExpandArrow() {
        UIView.animate(withDuration: 0.25, animations: {
            self.button.transform = self.button.transform.rotated(by: CGFloat.pi)
        })
    }
}
