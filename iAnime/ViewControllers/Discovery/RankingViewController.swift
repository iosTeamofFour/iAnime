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
    
    private var initialContentSize : CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override var rootView: UIView {
        return container
    }
    
    override func OnCollpased() {
        var size = container.SubviewsContentSize().size
        size.height += ContentSpacing
        print(size)
        scroller.contentSize = size
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var size = container.SubviewsContentSize().size
        size.height += ContentSpacing
        scroller.contentSize = size
        initialContentSize = size
    }
    
    override func OnLoadFrameInfoFromContainer() {
        // 在此已知rootview的frame size
        if FirstInsertedToContainer {
            LoadFakeData()
        }
        super.OnLoadFrameInfoFromContainer()
    }
    
    
    
    private func LoadFakeData() {
        if let storyboard = self.storyboard {
            let content1View = CollapsedView("最受欢迎的上色")
            let content1Controller = storyboard.instantiateViewController(withIdentifier: "MostFavoriteIllustration")
            let content1 = CollapsedContent(CollapsedViewHeader: content1View, CollapsedViewContent: content1Controller)
            
            
//            if let grid = content1Controller.view.subviews[0] as? GridView {
//
//                // 立刻修正从故事版new出来的Controller的frame异常
//                grid.frame.size = itemSize
//                let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Name: "Zhengzeming", UploadDate: Date())
//                let item1 = IllustrationItemView()
//                item1.illustration = illu1
//
//
//                let illu2 = Illustration(Image: UIImage(named: "Left-3")!, Name: "Huangpixuan", UploadDate: Date())
//                let item2 = IllustrationItemView()
//                item2.illustration = illu2
//
//
//                let illu3 = Illustration(Image: UIImage(named: "Left-0")!, Name: "郑泽帅明", UploadDate: Date())
//                let item3 = IllustrationItemView()
//                item3.illustration = illu3
//
//
//
//                let illu4 = Illustration(Image: UIImage(named: "Left-1")!, Name: "屁明屁东西", UploadDate: Date())
//                let item4 = IllustrationItemView()
//                item4.illustration = illu4
//
//                grid.layoutSubviews()
//
//                grid.AddItem(item1)
//                grid.AddItem(item2)
//                grid.AddItem(item3)
//                grid.AddItem(item4)
//            }
            
            AddContent(content1)
            
            let content2View = CollapsedView("最受欢迎的线稿")
            let content2Controller = storyboard.instantiateViewController(withIdentifier: "MostFavoriteDraft")
            let content2 = CollapsedContent(CollapsedViewHeader: content2View, CollapsedViewContent: content2Controller)
            
            
            if let grid = content2Controller.view.subviews[0] as? GridView {
                
                // 立刻修正从故事版new出来的Controller的frame异常
                grid.frame.size = itemSize
                grid.layoutSubviews()
                
//                let illu1 = Illustration(Image: UIImage(named: "Left-0")!, Name: "郑泽帅明", UploadDate: Date())
//
//                let item1 = IllustrationItemView()
//                item1.illustration = illu1
//                let illu2 = Illustration(Image: UIImage(named: "Left-1")!, Name: "屁明屁东西", UploadDate: Date())
//                let item2 = IllustrationItemView()
//                item2.illustration = illu2
//
//                grid.AddItem(item1)
//                grid.AddItem(item2)
            }
            
            AddContent(content2)
            
            // MostFork
            
            let content3View = CollapsedView("最受欢迎的创意")
            let content3Controller = storyboard.instantiateViewController(withIdentifier: "MostFork")
            let content3 = CollapsedContent(CollapsedViewHeader: content3View, CollapsedViewContent: content3Controller)
            AddContent(content3)
            
        }
    }
}
