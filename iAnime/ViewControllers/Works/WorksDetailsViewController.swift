//
//  WorksDetailsViewController.swift
//  iAnime
//
//  Created by Zoom on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import SnapKit

class WorksDetailsViewController: ReturnArrowViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var ContentStackView: UIStackView!
    @IBOutlet weak var AuthorID: UILabel!
    
    
    private var LabelCollectionView : UICollectionView!
    private var LabelCollectionViewFlow : UICollectionViewFlowLayout!
    private var LabelCollectionViewHeightConstraint : Constraint?

    private var FakeLabels : [WorkLabelItem] = [
        WorkLabelItem(title: "郑泽明", searchText: "郑泽屁明"),
        WorkLabelItem(title: "Relax", searchText: "Search Content"),
        WorkLabelItem(title: "广东爱情故事", searchText: "广东雨神"),
        WorkLabelItem(title: "郑泽明", searchText: "郑泽屁明"),
        WorkLabelItem(title: "Relax", searchText: "Search Content"),
        WorkLabelItem(title: "广东爱情故事", searchText: "广东雨神"),
        WorkLabelItem(title: "郑泽明", searchText: "郑泽屁明"),
        WorkLabelItem(title: "Relax", searchText: "Search Content"),
        WorkLabelItem(title: "广东爱情故事", searchText: "广东雨神")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        Image.isUserInteractionEnabled = true
        Image.addGestureRecognizer(singleTap)
        
        if #available(iOS 11.0, *) {
            ScrollView.contentInsetAdjustmentBehavior = .never
        }
        automaticallyAdjustsScrollViewInsets = false
        initView()
        InitLabelCollectionView()
        
    }

    //Action
    @objc func tapDetected() {
        let sb = UIStoryboard(name: "Index", bundle: nil)
        let imageViewer = sb.instantiateViewController(withIdentifier: "ImageViewer") as! PinchImageViewController
        imageViewer.Images.append(Image.image!)
        present(imageViewer, animated: true, completion: nil)
    }

    func initView()
    {
        let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Avatar:UIImage(named: "SampleAvatar")!,AuthorName:"zoom", Name: "sample",AuthorId:"100",Id:"110", UploadDate: Date(),Description:"诶我也不饿觉委屈就委屈非让我减肥认为弗兰克")
        Image.image=illu1.Image
        Name.text=illu1.Name
        ID.text=illu1.Id
        Avatar.image=illu1.Avatar
        Avatar.SetCircleBorder()
        AuthorID.text=illu1.AuthorId
        Description.text=illu1.Description
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FakeLabels.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkLabelCell", for: indexPath) as? WorkLabelCell else {
            print("Cannot dequeue cell specified")
            return UICollectionViewCell()
        }
        var lastPath = indexPath
        if lastPath.row > 0 {
            lastPath.row -= 1
            if let lastCell = collectionView.cellForItem(at: lastPath) as? WorkLabelCell {
                lastCell.ShowSeparator()
            }
        }
        let label = FakeLabels[indexPath.row]
        cell.InitCellContent(label.title, label.searchText)
        cell.HideSeparator()
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = LabelCollectionView.collectionViewLayout.collectionViewContentSize.height
        if height > 0 {
            LabelCollectionViewHeightConstraint?.update(offset: (height) + 30)
        }

    }
    
    
    
    private func InitLabelCollectionView() {
        LabelCollectionViewFlow = UICollectionViewFlowLayout()
        LabelCollectionViewFlow.scrollDirection = .vertical
        LabelCollectionViewFlow.minimumLineSpacing = 0
        LabelCollectionViewFlow.minimumInteritemSpacing = 4
        LabelCollectionViewFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LabelCollectionViewFlow.estimatedItemSize = CGSize(width: 1.0,height : 1.0)
        LabelCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: LabelCollectionViewFlow)
        
        LabelCollectionView.backgroundColor = UIColor.white
        LabelCollectionView.dataSource = self
        LabelCollectionView.delegate = self
        ContentStackView.addArrangedSubview(LabelCollectionView)
        LabelCollectionView.delaysContentTouches = false
        
        LabelCollectionView.register(WorkLabelCell.self, forCellWithReuseIdentifier: "WorkLabelCell")
        LabelCollectionView.snp.makeConstraints {
            make in
            make.width.equalToSuperview().offset(-30)
            self.LabelCollectionViewHeightConstraint = make.height.equalTo(50).constraint
            
        }
    }

}
