
//  PersonViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/13.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    

    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var FollowerCount: UILabel!
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var Signature: UILabel!
    
    @IBOutlet weak var TimelineContainer: UIStackView!
    private var TimelineCollectionView : UICollectionView!
    private var TimelineCollectionViewFlow : UICollectionViewFlowLayout!
    
    
    private var FakeData : Dictionary<String,[String]> = [
        "2019-9":[
            "Left-0",
            "Left-1",
            "Left-2"
        ],
        "2019-7":[
            "Left-3",
            "Left-4",
            "Left-5"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func InitTimelineCollectionView() {
        TimelineCollectionViewFlow = UICollectionViewFlowLayout()
        
        TimelineCollectionViewFlow.scrollDirection = .vertical
        TimelineCollectionViewFlow.minimumInteritemSpacing = 8
        TimelineCollectionViewFlow.minimumLineSpacing = 12
        
        let ContainerWidth = TimelineContainer.frame.width
        // One line 4 item
        let ItemWidth = (ContainerWidth - (4-1) * 8)/4
        TimelineCollectionViewFlow.itemSize = CGSize(width: ItemWidth, height: ItemWidth)
        
        
        TimelineCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: TimelineCollectionViewFlow)
        TimelineCollectionView.delegate = self
        TimelineCollectionView.dataSource = self
        TimelineCollectionView.register(TimelineItemCell.self, forCellWithReuseIdentifier: "TimelineItemCell")
    }
    
    
    
    // 展示Timeline的CollectionView逻辑
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
}
