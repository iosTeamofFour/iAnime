////
////  WorksDetailsViewController.swift
////  iAnime
////
////  Created by Zoom on 2019/10/24.
////  Copyright © 2019 NemesissLin. All rights reserved.
////
//
//import UIKit
//
//class WorksDetailsViewController: ReturnArrowViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    @IBOutlet weak var ScrollView: UIScrollView!
//    @IBOutlet weak var Image: UIImageView!
//    @IBOutlet weak var Name: UILabel!
//    @IBOutlet weak var ID: UILabel!
//    @IBOutlet weak var Avatar: UIImageView!
//    @IBOutlet weak var AuthorID: UILabel!
//    @IBOutlet weak var Description: UILabel!
//    @IBOutlet weak var LabelStackView: UIStackView!
//
//    private var LabelCollectionView : UICollectionView!
//    private var LabelCollectionViewFlow : UICollectionViewFlowLayout!
//    private var LabelCollectionViewHeightConstraint : NSLayoutConstraint?
//
//    @IBAction func SearchTag(_ sender: Any) {
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initView()
//        initLabelCollectionView()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        ScrollView.contentSize=CGSize.init(width: 375, height: 800)
//    }
//
//    func initView()
//    {
//        let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Avatar:UIImage(named: "SampleAvatar")!,AuthorName:"zoom", Name: "sample",AuthorId:"100",Id:"110", UploadDate: Date(),Description:"诶我也不饿觉委屈就委屈非让我减肥认为弗兰克黑色风格和法国文化氛围分阿拉维减肥啊师傅却忘了带我回到凤凰网色")
//        Image.image=illu1.Image
//        Name.text=illu1.Name
//        ID.text=illu1.Id
//        Avatar.image=illu1.Avatar
//        Avatar.SetCircleBorder()
//        AuthorID.text=illu1.AuthorId
//        Description.text=illu1.Description
//    }
//
//
//
//
//
//
//
//    private func initLabelCollectionView() {
//
//        LabelCollectionViewFlow = UICollectionViewFlowLayout()
//        LabelCollectionViewFlow.scrollDirection = .vertical
//        LabelCollectionViewFlow.minimumInteritemSpacing = 8
//        LabelCollectionViewFlow.minimumLineSpacing = 8
//
//        let ContainerWidth = LabelStackView.frame.width
//        // One line 4 item
//        let ItemWidth = (ContainerWidth - (5-1) * 8)/5
//        LabelCollectionViewFlow.itemSize = CGSize(width: ItemWidth, height: ItemWidth)
//        LabelCollectionViewFlow.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//        LabelCollectionViewFlow.headerReferenceSize = CGSize(width: LabelStackView.frame.width - 20, height: 45)
//        LabelCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: LabelCollectionViewFlow)
//
//
//        LabelCollectionView.backgroundColor = UIColor.white
//        LabelCollectionView.delegate = self
//        LabelCollectionView.dataSource = self
//
//        //LabelCollectionView.register(TimelineItemCell.self, forCellWithReuseIdentifier: "TimelineItemCell")
//
//        LabelStackView.addArrangedSubview(LabelCollectionView)
//        LabelCollectionViewHeightConstraint = LabelCollectionView.heightAnchor.constraint(equalToConstant: 1).Activate()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//}
