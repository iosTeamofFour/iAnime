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
    
    @IBInspectable var rowSpacing : CGFloat = 8
    @IBInspectable var columnSpacing : CGFloat = 8
    @IBInspectable var columnCount : Int = 2
    
    private(set) var EachColWidth : CGFloat = 0
    
    private var ColStackViews : [UIStackView] = []
    
    var OnPlacedGrid : ((GridView) -> Void)?
    
    private var FinishPlaceColStackView = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if ColStackViews.count == 0 && !FinishPlaceColStackView {
            LayoutVerticalStackView()
        }
    }
    
    private func LayoutVerticalStackView() {
        
        let CurrentContainerWidth = frame.size.width
        EachColWidth = (CurrentContainerWidth - columnSpacing * CGFloat((columnCount - 1))) / CGFloat(columnCount)
        for i in 0..<columnCount {
            let stv = UIStackView()
            stv.axis = .vertical
            stv.translatesAutoresizingMaskIntoConstraints = false
            stv.spacing = rowSpacing
            let offset : CGFloat = CGFloat(i) * (columnSpacing + EachColWidth)
            
            addSubview(stv)
            
            stv.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset).isActive = true
            stv.addConstraint(NSLayoutConstraint(item: stv, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: EachColWidth))
            
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
