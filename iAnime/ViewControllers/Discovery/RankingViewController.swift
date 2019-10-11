//
//  CollapsedViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class RankingViewController: CollapsedViewController {
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var container: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadFakeData()
    }
    
    override var rootView: UIView {
        return container
    }
    override func AfterContainerItemChanged() {
        container.layoutIfNeeded()
        var size = container.SubviewsContentSize().size
        size.height += 16
        scroller.contentSize = size
        scroller.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AfterContainerItemChanged()
    }
    private func LoadFakeData() {
        if let storyboard = self.storyboard {
            let content1View = CollapsedView("最受欢迎的上色")
            let content1Controller = storyboard.instantiateViewController(withIdentifier: "MostFavoriteIllustration")
            let content1 = CollapsedContent(CollapsedViewHeader: content1View, CollapsedViewContent: content1Controller)
            
            
            let content2View = CollapsedView("最受欢迎的线稿")
            let content2Controller = storyboard.instantiateViewController(withIdentifier: "MostFavoriteDraft")
            let content2 = CollapsedContent(CollapsedViewHeader: content2View, CollapsedViewContent: content2Controller)
            
            // MostFork
            
            let content3View = CollapsedView("最受欢迎的创意")
            let content3Controller = storyboard.instantiateViewController(withIdentifier: "MostFork")
            let content3 = CollapsedContent(CollapsedViewHeader: content3View, CollapsedViewContent: content3Controller)
            
            AddContent(content1)
            AddContent(content2)
            AddContent(content3)
        }
    }
}
