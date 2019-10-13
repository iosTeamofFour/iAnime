//
//  GridView.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
@IBDesignable
class GridView: UIScrollView {
    
    @IBInspectable var ignoreIBWidth : CGFloat = 0
    @IBInspectable var rowSpacing : CGFloat = 8
    @IBInspectable var columnSpacing : CGFloat = 8
    @IBInspectable var columnCount : Int = 2
    
    private(set) var EachColWidth : CGFloat = 0
    
    private var ColStackViews : [UIStackView] = []
    private var ColStackViewsConstraints : [(NSLayoutConstraint,NSLayoutConstraint)] = []
    
    private var WidthFromIB : CGFloat = -1
    
    var OnPlacedGrid : ((GridView) -> Void)?
    
    private var FinishPlaceColStackView = false
    private var FinishResizeContainer = false
    override func layoutSubviews() {
        super.layoutSubviews()
        delaysContentTouches = false
        if !FinishPlaceColStackView {
            LayoutVerticalStackView()
        }
//        else if !FinishResizeContainer {
//            // Update width
//            let newColWidth = UpdateEachColWidth()
//
//            for i in 0..<ColStackViewsConstraints.count {
//                let sv = ColStackViews[i]
//                let (leading, width) = ColStackViewsConstraints[i]
//
//                leading.constant = CGFloat(i) * (columnSpacing + EachColWidth)
//                width.constant = newColWidth
//                sv.updateConstraints()
//            }
//            UpdateContentSize()
//            FinishResizeContainer = true
//        }
    }
    
    
    func UpdateEachColWidth() -> CGFloat {
        let frameSize = frame.size.width
        var CurrentContainerWidth : CGFloat = 0.0
        CurrentContainerWidth = frameSize
        
        EachColWidth = (CurrentContainerWidth - columnSpacing * CGFloat((columnCount - 1))) / CGFloat(columnCount)
        return EachColWidth
    }
    
    func SingleItemSize() -> CGSize? {
        let fi = ColStackViews.first(where: { sv in sv.arrangedSubviews.count > 0 })?.arrangedSubviews.first
        return fi?.frame.size
    }
    
    private func LayoutVerticalStackView() {
        EachColWidth = UpdateEachColWidth()
        for i in 0..<columnCount {
            let stv = UIStackView()
            stv.axis = .vertical
            stv.translatesAutoresizingMaskIntoConstraints = false
            stv.spacing = rowSpacing
            let offset : CGFloat = CGFloat(i) * (columnSpacing + EachColWidth)
            
            addSubview(stv)
            
            stv.topAnchor.constraint(equalTo: topAnchor).isActive = true
            let leadingConstraint = stv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset).Activate()
            let widthConstraint = NSLayoutConstraint(item: stv, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: EachColWidth)
            stv.addConstraint(widthConstraint)
            
            ColStackViewsConstraints.append((leadingConstraint,widthConstraint))
            ColStackViews.append(stv)
        }
        FinishPlaceColStackView = true
        OnPlacedGrid?(self)
    }
    
    func AddItem(_ item : UIView) {
        let ItemCount = ColStackViews.map({ v in v.arrangedSubviews.count }).reduce(0, {a,b in a+b})
        let ShouldPlacedColIndex = (ItemCount) % columnCount
        AddItemAtColSpecified(item, ShouldPlacedColIndex)
    }
    
    func AddItemAtColSpecified(_ item : UIView, _ index : Int) {
        if !ColStackViews.InRange(index) {
            print("Cannot add item at \(index) out of range!")
            return
        }
        ColStackViews[index].addArrangedSubview(item)
        ColStackViews[index].layoutIfNeeded()
        UpdateContentSize()
    }
    
    func UpdateContentSize() {
        // 立即更新ScrollView的ContentSize，感知滚动条长度变化。
        ColStackViews.forEach { v in v.layoutIfNeeded() }
        var NewContentSize = ColStackViews.flatMap({ v in v.arrangedSubviews }).map({ v in v.frame}).reduce(CGRect.zero, { a,b in a.union(b)}).size
        NewContentSize.height += rowSpacing
        contentSize = NewContentSize
    }
}
