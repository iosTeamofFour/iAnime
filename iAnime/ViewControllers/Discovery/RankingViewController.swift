//
//  CollapsedViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class RankingViewController: CollapsedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadFakeData()
    }
    
    private func LoadFakeData() {
        if let storyboard = self.storyboard {
            let content1View = CollapsedView("最受欢迎的上色")
            let content1Controller = storyboard.instantiateViewController(withIdentifier: "MostFavoriteIllustration")
            let content1 = CollapsedContent(CollapsedViewHeader: content1View, CollapsedViewContent: content1Controller)
            
            
            let content2View = CollapsedView("最受欢迎的线稿")
            let content2Controller = storyboard.instantiateViewController(withIdentifier: "MostFavoriteDraft")
            let content2 = CollapsedContent(CollapsedViewHeader: content2View, CollapsedViewContent: content2Controller)
            
            
            AddContent(content1)
            AddContent(content2)
        }
    }
}
