
//  PersonViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/13.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PersonViewController: ReturnArrowViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var FollowerCount: UILabel!
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var Signature: UILabel!

    @IBOutlet weak var TimelineContainer: UIStackView!
    
    private var TimelineCollectionView : UICollectionView!
    private var TimelineCollectionViewFlow : UICollectionViewFlowLayout!
    
    private var TimelineCollectionViewHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet weak var FollowUserButton: MultistateButton!
    
    private var FakeData : [Pair<String,[String]>] = [
        Pair("2019-09", [
            "Left-0",
            "Left-1",
            "Left-2",
            "Left-3",
            "Left-4"
            ]),
        Pair("2019-07", [
            "Left-0",
            "Left-1",
            "Left-2",
            "Left-3",
            "Left-4"
            ])
    ]
    @IBOutlet weak var Scroller: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 关闭自动计算安全区域大小的功能
        if #available(iOS 11.0, *) {
            Scroller.contentInsetAdjustmentBehavior = .never
        }
        automaticallyAdjustsScrollViewInsets = false
        AvatarImage.SetCircleBorder()
        InitTimelineCollectionView()
        InitFollowButton()
    }
    
    private func InitFollowButton() {
        let states : [ButtonState] = [
            ButtonState("关注", UIImage(named: "AddNoCircle"),nil,UIColor.init(red: 0, green: 118/255, blue: 1, alpha: 1), OnClickFollowUser),
            ButtonState("已关注",UIImage(named: "Checkmark"), nil, UIColor.gray, OnClickFollowUser)
        ]
        
        FollowUserButton.AddStates(states)
    }
    
    private func OnClickFollowUser(_ sender: MultistateButton) {
        // Do something here
        sender.NextState((sender.CurrentState + 1) % sender.ButtonState.count)
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 控制时间线CollectionView显示
    
    
    private func InitTimelineCollectionView() {
        
        TimelineCollectionViewFlow = UICollectionViewFlowLayout()
        TimelineCollectionViewFlow.scrollDirection = .vertical
        TimelineCollectionViewFlow.minimumInteritemSpacing = 8
        TimelineCollectionViewFlow.minimumLineSpacing = 8
        
        let ContainerWidth = TimelineContainer.frame.width
        // One line 4 item
        let ItemWidth = (ContainerWidth - (4-1) * 8)/4
        TimelineCollectionViewFlow.itemSize = CGSize(width: ItemWidth, height: ItemWidth)
        TimelineCollectionViewFlow.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        TimelineCollectionViewFlow.headerReferenceSize = CGSize(width: TimelineContainer.frame.width - 20, height: 45)
        TimelineCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: TimelineCollectionViewFlow)
        
        
        TimelineCollectionView.backgroundColor = UIColor.white
        TimelineCollectionView.delegate = self
        TimelineCollectionView.dataSource = self
        
        // 注册Cell类型和Header类型
        TimelineCollectionView.register(TimelineItemCell.self, forCellWithReuseIdentifier: "TimelineItemCell")
        TimelineCollectionView.register(TimelineHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TimelineHeader")
        
        TimelineContainer.addArrangedSubview(TimelineCollectionView)
        
        TimelineCollectionViewHeightConstraint = TimelineCollectionView.heightAnchor.constraint(equalToConstant: 1).Activate()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FakeData.count
    }
    
    // 展示Timeline的CollectionView逻辑
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FakeData[section].value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineItemCell", for: indexPath)
        if let timelineCell = cell as? TimelineItemCell {
            let data = FakeData[indexPath.section]
            let imageIdentifier = data.value[indexPath.row]
            let loadedImage = UIImage(named: imageIdentifier)
            timelineCell.imageView.image = loadedImage
        }
        UpdateTimelineCollectionViewHeight()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! TimelineItemCell
        
        let sb = UIStoryboard(name: "Index", bundle: nil)
        let imageViewer = sb.instantiateViewController(withIdentifier: "ImageViewer") as! PinchImageViewController
        
        imageViewer.Images.append(cell.imageView.image!)
        present(imageViewer, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ContainerWidth = TimelineContainer.frame.width
        // One line 4 item
        let ItemWidth = (ContainerWidth - (4-1) * 8)/4
        return CGSize(width: ItemWidth, height: ItemWidth)
    }

//    如果需要特判Header的高度, 就需要override这个函数了。
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: TimelineContainer.frame.width - 20, height: 45)
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let title = FakeData[indexPath.section]
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TimelineHeader", for: indexPath)
            if let timelineHeader = headerView as? TimelineHeader {
                timelineHeader.header.text = title.key
            }
            UpdateTimelineCollectionViewHeight()
            return headerView
        default:
            print("Unexpected element kind \(kind), exit.")
        }
        return TimelineHeader()
    }
    
    private func UpdateTimelineCollectionViewHeight() {
        if let constraint = TimelineCollectionViewHeightConstraint {
            constraint.isActive = false
            TimelineCollectionView.removeConstraint(constraint)
        }
        
        let contentSize = TimelineCollectionView.collectionViewLayout.collectionViewContentSize.height
        TimelineCollectionViewHeightConstraint = TimelineCollectionView.heightAnchor.constraint(equalToConstant: contentSize).Activate()
    }
}
