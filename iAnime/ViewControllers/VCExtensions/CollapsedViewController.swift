//
//  CollapsedViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/10.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class CollapsedViewController: FragmentViewController {

    
    private var Contents : [CollapsedContent] = []
    private var ContentsConstraints : [CollapsedContentConstraints] = []
    private var CurrentExpandItemConstraints = CollapsedContentConstraints(HeaderConstraints: [], ContentConstraints: [])
    
    @IBInspectable var ContentHeaderPaddingLeft : CGFloat = 16.0
    @IBInspectable var ContentSpacing : CGFloat = 8.0
    @IBInspectable var ContentDetailPaddingLeading : CGFloat = 16.0
    @IBInspectable var ContentDetailPaddingTrailing : CGFloat = 16.0
    @IBInspectable var ContentAndHeaderSpacing : CGFloat = 8.0
    @IBInspectable var ContentHeightInCollapsedMode : CGFloat = 150.0
    
    private var CurrentExpandedItemIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func AddContent(_ content : CollapsedContent) {
        
        LayoutContent(content, Contents.count == 0)
        
        Contents.append(content)
    }
    
    private func LayoutContent(_ content : CollapsedContent, _ isAtTop : Bool) {
        
        let header = content.CollapsedViewHeader
        let ctn = content.CollapsedViewContent
        
        let ctnView = ctn.view!
        
        header.translatesAutoresizingMaskIntoConstraints = false
        ctnView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(header)
        view.addSubview(ctnView)
        header.layoutSubviews()
        
        LayoutItemInCollapsedMode(isAtTop, content)
    }
    
    
    private func LayoutItemInCollapsedMode(_ isAtTop : Bool, _ content : CollapsedContent) {
        
        let header = content.CollapsedViewHeader
        let ctn = content.CollapsedViewContent
        let ctnView = ctn.view!
        
        var consts = CollapsedContentConstraints(HeaderConstraints: [], ContentConstraints: [])
        
        // 判断当前加载的是不是第一个
        if isAtTop {
            // 如果是, 那么只能与Superview进行约束
            consts.HeaderConstraints.append(header.topAnchor.constraint(equalTo: view.topAnchor, constant: ContentSpacing).Activate())
        }
        else {
            consts.HeaderConstraints.append(header.topAnchor.constraint(equalTo: Contents.last!.CollapsedViewContent.view.bottomAnchor, constant: ContentSpacing).Activate())
        }
        consts.HeaderConstraints.append(header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContentHeaderPaddingLeft).Activate())
        
        consts.ContentConstraints.append(ctnView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: ContentAndHeaderSpacing).Activate())
        
        consts.ContentConstraints.append(ctnView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContentDetailPaddingLeading).Activate())
        
        consts.ContentConstraints.append(ctnView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ContentDetailPaddingTrailing).Activate())
        
        consts.ContentConstraints.append(ctnView.heightAnchor.constraint(equalToConstant: ContentHeightInCollapsedMode).Activate())
        
        // 将当前视图的全部约束添加到数组中管理.
        ContentsConstraints.append(consts)
        
        header.OnExpandedToggled = HandleComponentToggleExpand
        view.layoutIfNeeded()
    }
    
    private func LayoutItemInExpandedMode(_ expandedContent : CollapsedContent) {
        let header = expandedContent.CollapsedViewHeader
        let ctnView = expandedContent.CollapsedViewContent.view!
        
        var currConsts = CurrentExpandItemConstraints
        
        currConsts.HeaderConstraints.append(header.topAnchor.constraint(equalTo: view.topAnchor, constant: ContentSpacing).Activate())
        currConsts.HeaderConstraints.append(header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContentHeaderPaddingLeft).Activate())
        
        
        currConsts.ContentConstraints.append(ctnView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: ContentAndHeaderSpacing).Activate())
        currConsts.ContentConstraints.append(ctnView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContentDetailPaddingLeading).Activate())
        currConsts.ContentConstraints.append(ctnView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ContentDetailPaddingTrailing).Activate())
        currConsts.ContentConstraints.append(ctnView.bottomAnchor.constraint(equalTo: view.bottomAnchor).Activate())
    }
    
    private func RemoveAllConstraintsForManagedItem(_ itemIndex: Int) {
        let item = Contents[itemIndex]
        let itemConstraints = ContentsConstraints[itemIndex]
        item.CollapsedViewHeader.removeConstraints(itemConstraints.HeaderConstraints)
        item.CollapsedViewContent.view.removeConstraints(itemConstraints.ContentConstraints)
        
    }
    
    
    private func RecoverFromExpanded() {
        
        //去除当前正在展示的Item的全部约束。
        let item = Contents[CurrentExpandedItemIndex]
        let itemConstraints = CurrentExpandItemConstraints
        item.CollapsedViewHeader.removeConstraints(itemConstraints.HeaderConstraints)
        item.CollapsedViewContent.view.removeConstraints(itemConstraints.ContentConstraints)
        item.CollapsedViewHeader.removeFromSuperview()
        item.CollapsedViewContent.view.removeFromSuperview()
        
        //添加回原来的约束。
        for i in 0..<Contents.count {
            
            // 修复显示
            let content = Contents[i]
            LayoutContent(content, i == 0)
        }
        
        //清除掉上次保存的展示约束。
        CurrentExpandItemConstraints.ContentConstraints.removeAll()
        CurrentExpandItemConstraints.HeaderConstraints.removeAll()
        CurrentExpandedItemIndex = -1
    }
    
    private func HandleComponentToggleExpand(_ isExpand : Bool, _ collapsedView : CollapsedView) {
        print("当前控件 \(collapsedView) 展开状况 \(isExpand)")
        if isExpand {
            let index = IndexOfContents(collapsedView)
            
            if index == -1 {
                print("Cannot find the content to expand.")
                return
            }
            
            for i in 0..<Contents.count {
                
                RemoveAllConstraintsForManagedItem(i)
                if i != index {
                    
                    let item = Contents[i]
                    item.CollapsedViewHeader.removeFromSuperview()
                    item.CollapsedViewContent.view.removeFromSuperview()
                }
            }
            
            // 旧的约束已经没用了, Clear.
            ContentsConstraints.removeAll()
            
            CurrentExpandedItemIndex = index
            LayoutItemInExpandedMode(Contents[index])
        }
        else {
            RecoverFromExpanded()
        }
        view.layoutIfNeeded()
    }
    
    
    private func IndexOfContents(_ itemHeader : CollapsedView) -> Int {
        for (i,item) in Contents.enumerated() {
            if item.CollapsedViewHeader == itemHeader {
                return i
            }
        }
        return -1
    }
}
