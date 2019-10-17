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
    
    @IBInspectable var ContentDetailPaddingLeading : CGFloat = 4.0
    @IBInspectable var ContentDetailPaddingTrailing : CGFloat = 4.0
    
    @IBInspectable var ContentAndHeaderSpacing : CGFloat = 8.0
    @IBInspectable var ContentHeightInCollapsedMode : CGFloat = 150.0
    
    private var CurrentExpandedItemIndex = -1
    var parentScrollerOffset : CGFloat = 0.0
    @IBInspectable var WithAnimation = true
    var IsExpanded = false
    
    private var CollapseAnimation = InorderAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var rootView : UIView {
        get {
            print("当前获取的是此默认滚动控制器的根view, 如非预期请确认是否正确overridev此变量.")
            return view
        }
    }
    
    func AfterContainerItemChanged(_ isExpanded : Bool)  {
        print("当前回调的是默认滚动控制器的AfterContainerItemChanged，此方法什么都没实现，如果需要手动计算滚动区域高度，请确认是否正确override此函数.")
    }
    
    var itemSize : CGSize {
        get {
            var rootSize = rootView.frame.size
            rootSize.width -= ContentDetailPaddingLeading + ContentDetailPaddingTrailing
            return rootSize
        }
    }
    
    func OnCollpased() {
        // stub
    }
    
    func OnExpanded() {
        // stub
    }
    
    func AddContent(_ content : CollapsedContent) {
        LayoutContent(content)
        Contents.append(content)
    }
    
    
    private func AddContentToContainer(_ content : CollapsedContent) {
        let header = content.CollapsedViewHeader
        header.alpha = 1
        header.translatesAutoresizingMaskIntoConstraints = false
        header.layoutSubviews()
        
        let ctn = content.CollapsedViewContent
        let ctnView = ctn.view!
        ctnView.translatesAutoresizingMaskIntoConstraints = false
        ctnView.alpha = 1

        rootView.addSubview(header)
        rootView.addSubview(ctnView)
    }
    
    private func RemoveContentFromContainer(_ item : CollapsedContent) {
        // 将当前展示的View移除管理容器
        item.CollapsedViewHeader.removeFromSuperview()
        item.CollapsedViewContent.view.removeFromSuperview()
    }
    
    
    private func LayoutContent(_ content : CollapsedContent) {
        
        AddContentToContainer(content)
        LayoutItemInCollapsedMode(content, Contents.last)
    }

    private func LayoutContent(_ content : CollapsedContent, lastContent : CollapsedContent?) {
        
        AddContentToContainer(content)
        LayoutItemInCollapsedMode(content, lastContent)
    }
    
    private func LayoutItemInCollapsedMode(_ content : CollapsedContent, _ lastContent : CollapsedContent?) {
        
        let header = content.CollapsedViewHeader
        let ctn = content.CollapsedViewContent
        let ctnView = ctn.view!
        var heightConstraint : CGFloat = ContentHeightInCollapsedMode
        
        if let grid = ctnView.subviews.first as? GridView,let singleSize = grid.SingleItemSize() {
            print(singleSize)
            heightConstraint = singleSize.height
        }
        print("最终HeightConstraint: \(heightConstraint)")
        var consts = CollapsedContentConstraints(HeaderConstraints: [], ContentConstraints: [])
        
        // 判断当前加载的是不是第一个
        if lastContent == nil {
            // 如果是, 那么只能与Superview进行约束
            consts.HeaderConstraints.append(header.topAnchor.constraint(equalTo: rootView.topAnchor, constant: ContentSpacing).Activate())
        }
        else {
            consts.HeaderConstraints.append(header.topAnchor.constraint(equalTo: lastContent!.CollapsedViewContent.view.bottomAnchor, constant: ContentSpacing).Activate())
        }
        consts.HeaderConstraints.append(header.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: ContentHeaderPaddingLeft).Activate())
        
        consts.ContentConstraints.append(ctnView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: ContentAndHeaderSpacing).Activate())
        
        consts.ContentConstraints.append(ctnView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: ContentDetailPaddingLeading).Activate())
        
        consts.ContentConstraints.append(ctnView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -ContentDetailPaddingTrailing).Activate())
        
        consts.ContentConstraints.append(ctnView.heightAnchor.constraint(equalToConstant: heightConstraint).Activate())
        
        // 将当前视图的全部约束添加到数组中管理.
        ContentsConstraints.append(consts)
        
        header.OnExpandedToggled = HandleComponentToggleExpand
//        header.layoutIfNeeded()
//        ctnView.layoutIfNeeded()
//        rootView.layoutIfNeeded()
        AfterContainerItemChanged(IsExpanded)
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
        AfterContainerItemChanged(IsExpanded)
    }
    
    private func RemoveAllConstraintsForManagedItem(_ itemIndex: Int) {
        
        let itemConstraints = ContentsConstraints[itemIndex]
        RemoveAllConstraintsForManagedItem(itemIndex, itemConstraints)
        
    }
    
    private func RemoveAllConstraintsForManagedItem(_ itemIndex: Int, _ constraints : CollapsedContentConstraints) {
        let item = Contents[itemIndex]
        let itemConstraints = constraints
        item.CollapsedViewHeader.removeConstraints(itemConstraints.HeaderConstraints)
        item.CollapsedViewContent.view.removeConstraints(itemConstraints.ContentConstraints)
        
    }
    

    private func RecoverFromExpanded() {
        //去除当前正在展示的Item的全部约束。
        RemoveAllConstraintsForManagedItem(CurrentExpandedItemIndex, CurrentExpandItemConstraints)
        RemoveContentFromContainer(Contents[CurrentExpandedItemIndex])
        
        self.CurrentExpandItemConstraints.ContentConstraints.removeAll()
        self.CurrentExpandItemConstraints.HeaderConstraints.removeAll()
        //添加回原来的约束。
        if WithAnimation {

            
            CollapseAnimation.AddAnimation(animation: ExecuteAnimation.init(Duration: 0.25, Delay: 0, Options: .curveEaseInOut, WhenComplete: {
                _ in

                self.CurrentExpandedItemIndex = -1
                self.CollapseAnimation.RemoveAllAnimation()
                self.OnCollpased()
            }, DoAnimation: {
                for i in 0..<self.Contents.count {
                    // 修复显示
                    self.LayoutContent(self.Contents[i],lastContent: i == 0 ? nil : self.Contents[i-1])
                    self.rootView.layoutIfNeeded()
                }
            }))
            
            CollapseAnimation.Begin()
            return
        }
        
        // 没有动画直接执行普通结果
        for i in 0..<Contents.count {
            // 修复显示
            LayoutContent(Contents[i],lastContent: i == 0 ? nil : Contents[i-1])
        }
        // 清除掉上次保存的展示约束。
        CurrentExpandedItemIndex = -1
        OnCollpased()
    }
    
    private func HideContentsActualAction(_ contents: [(Int, CollapsedContent)]) {
        contents.forEach {
            (index, item) in
            RemoveAllConstraintsForManagedItem(index)
            RemoveContentFromContainer(item)
        }
    }
    
    private func HandleComponentToggleExpand(_ isExpand : Bool, _ collapsedView : CollapsedView) {

        IsExpanded = isExpand
        
        if let root = rootView.superview as? UIScrollView {
            if isExpand {
                parentScrollerOffset = root.contentOffset.y
                root.isScrollEnabled = false
            }
            else {
                root.isScrollEnabled = true
            }
        }
        
        if isExpand {
            
            let index = IndexOfContents(collapsedView)
            if index == -1 {
                print("Cannot find the content to expand.")
                return
            }
            
            // 计算哪些Item需要被隐藏
            let ShouldHideContents = Contents.enumerated().filter { (index, item) in item.CollapsedViewHeader != collapsedView }
            CurrentExpandedItemIndex = index
            
            if WithAnimation {
                CollapseAnimation.AddAnimation(animation: ExecuteAnimation(Duration: 0.25, Delay: 0, Options: .curveEaseInOut, WhenComplete: {
                    _ in
                    // 清除掉待展开对象目前在折叠模式下的约束
                    self.RemoveAllConstraintsForManagedItem(index)
                }, DoAnimation: {
                    ShouldHideContents.forEach { (_,item) in
                        item.CollapsedViewHeader.alpha = 0
                        item.CollapsedViewContent.view.alpha = 0
                    }
                }))
                CollapseAnimation.AddAnimation(animation: ExecuteAnimation.init(Duration: 0.25, Delay: 0, Options: .curveEaseInOut, WhenComplete: {
                    _ in
                    self.HideContentsActualAction(ShouldHideContents)
                    self.ContentsConstraints.removeAll()
                    self.CollapseAnimation.RemoveAllAnimation()
                    self.OnExpanded()
                }, DoAnimation: {
                    self.LayoutItemInExpandedMode(self.Contents[index])
                    // 强制触发视图层更新动画
                    self.view.layoutIfNeeded()
                }))
                CollapseAnimation.Begin()
                return
            }
            
            // 普通过程
            
            RemoveAllConstraintsForManagedItem(index)
            HideContentsActualAction(ShouldHideContents)
            ContentsConstraints.removeAll()
            LayoutItemInExpandedMode(Contents[index])
            OnExpanded()
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
