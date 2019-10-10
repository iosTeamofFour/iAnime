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
    
    @IBInspectable var ContentHeaderPaddingLeft : CGFloat = 16.0
    @IBInspectable var ContentSpacing : CGFloat = 8.0
    @IBInspectable var ContentDetailPaddingLeading : CGFloat = 16.0
    @IBInspectable var ContentDetailPaddingTrailing : CGFloat = 16.0
    @IBInspectable var ContentAndHeaderSpacing : CGFloat = 8.0
    @IBInspectable var ContentHeightInCollapsedMode : CGFloat = 150.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func AddContent(_ content : CollapsedContent) {
        
        LayoutContent(content)
        view.layoutIfNeeded()
        Contents.append(content)
    }
    
    private func LayoutContent(_ content : CollapsedContent) {
        
        let header = content.CollapsedViewHeader
        let ctn = content.CollapsedViewContent
        
        let ctnView = ctn.view!
        
        header.translatesAutoresizingMaskIntoConstraints = false
        ctnView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(header)
        view.addSubview(ctnView)
        header.layoutSubviews()
        
        var consts = CollapsedContentConstraints(HeaderConstraints: [], ContentConstraints: [])
        
        // 判断当前加载的是不是第一个
        if Contents.count == 0 {
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
        
        
        header.OnExpandedToggled = HandleComponentToggleExpand
    }
    
    private func HandleComponentToggleExpand(_ isExpand : Bool, _ collapsedView : CollapsedView) {
        print("当前控件 \(collapsedView) 展开状况 \(isExpand)")
        
        
    }
}
