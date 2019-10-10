//
//  CollapsedViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class RankingViewController: FragmentViewController {

    private var Contents : [CollapsedContent] = []
    
    @IBInspectable var ContentHeaderPaddingLeft : CGFloat = 16.0
    @IBInspectable var ContentSpacing : CGFloat = 8.0
    @IBInspectable var ContentDetailPaddingLeading : CGFloat = 16.0
    @IBInspectable var ContentDetailPaddingTrailing : CGFloat = 16.0
    @IBInspectable var ContentAndHeaderSpacing : CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func AddContent(_ content : CollapsedContent) {
        
        LayoutContent(content)
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
        
        // 判断当前加载的是不是第一个
        if Contents.count == 0 {
            // 如果是, 那么只能与Superview进行约束
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: ContentSpacing).isActive = true
        }
        else {
            header.topAnchor.constraint(equalTo: Contents.last!.CollapsedViewContent.view.bottomAnchor, constant: ContentSpacing).isActive = true
        }
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContentHeaderPaddingLeft).isActive = true
        
        ctnView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: ContentAndHeaderSpacing).isActive = true
        
        ctnView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContentDetailPaddingLeading).isActive = true
        
        ctnView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ContentDetailPaddingTrailing).isActive = true
    }
}
