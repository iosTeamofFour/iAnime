//
//  IndexIlluGridViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class IndexIlluGridViewController: IndexViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var IlluGridView: UICollectionView!
    @IBOutlet weak var Searcher: UISearchBar!
    
    private(set) var IlluType = [
        "本地作品",
        "发布的作品"
    ]
    
    private let DEQUEUE_ITEM_IDENTIFIER = "IlluItemCell"
    
    private let DEQUEUE_HEADER_IDENTIFIER = "IlluItemHeader"
    
    private let DEQUEUE_EMPTY_IDENTIFIER = "IlluEmptyFooter"
    
    
    private var FakeData : [[(DrawingInfo, Data)]] = []
    
    private var AllData : [[(DrawingInfo, Data)]] = []
    
    private var ShouldInitIlluGridView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitSearcherListener()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         LoadDataFromLocal()
    }
    
    private func LoadDataFromServer() {
        // TODO -- Should Return [Illustration]
    }
    
    private func LoadDataFromLocal() {
        // TODO -- Should Return [Illustration]

        DispatchQueue.global().async {
            let allWorksURL = PersistenceManager.ListAllLocalWork()
            let worksData = PersistenceManager
                                .LoadAllLocalWorkDrawingInfo(allWorksURL)
                                .map { (info, png) in (info!,png!) }
                                .sorted(by: {(a,b) in a.0.CreatedTime > b.0.CreatedTime })
            
            self.FakeData = [worksData,[]]
            self.AllData = [worksData,[]]
            DispatchQueue.main.async {
                self.IlluGridView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if ShouldInitIlluGridView {
            InitIlluGridView()
            ShouldInitIlluGridView = false
        }
    }
    
    private func InitSearcherListener() {
        Searcher.delegate = self
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
//        if let searchedText = searchBar.text, (searchedText as NSString).length > 0 {
//
//            var localSearched : [Illustration] = []
//            var networkSearched : [Illustration] = []
//
//            for item in AllData[0] {
//                if item.Name.contains(searchedText) {
//                    localSearched.append(item)
//                }
//            }
//
//            for item in AllData[1] {
//
//                if item.Name.contains(searchedText) {
//                    networkSearched.append(item)
//                }
//            }
//
//            FakeData.removeAll()
//            FakeData += [localSearched,networkSearched]
//
//        }
//        else {
//            FakeData.removeAll()
//            FakeData += AllData
//        }
//        IlluGridView.reloadData()
    }
    
    private func InitIlluGridView() {
        // 设定delegate and datasource
        
        IlluGridView.delegate = self
        IlluGridView.dataSource = self
        
        // 设置布局属性
        let IlluGridFlowLayout = UICollectionViewFlowLayout()
        
        IlluGridFlowLayout.scrollDirection = .vertical
        IlluGridFlowLayout.minimumLineSpacing = 8
        IlluGridFlowLayout.minimumInteritemSpacing = 16
        
        IlluGridFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        IlluGridFlowLayout.headerReferenceSize = CGSize(width: IlluGridView.frame.width - 20, height: 60)
        let ItemWidth = (IlluGridView.frame.width - 20) / 2
        
        IlluGridFlowLayout.itemSize = CGSize(width: ItemWidth, height: 2.1 * ItemWidth)
        
        IlluGridView.collectionViewLayout = IlluGridFlowLayout
        IlluGridView.backgroundColor = UIColor.white
        IlluGridView.register(IlluItemCell.self, forCellWithReuseIdentifier: DEQUEUE_ITEM_IDENTIFIER)
        
        IlluGridView.register(IlluItemHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DEQUEUE_HEADER_IDENTIFIER)
        
        IlluGridView.register(IlluEmptyFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DEQUEUE_EMPTY_IDENTIFIER)
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return IlluType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FakeData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DEQUEUE_ITEM_IDENTIFIER, for: indexPath)
        if let itemCell = cell as? IlluItemCell {
            
            let (info,data) = FakeData[indexPath.section][indexPath.row]
            let illuView = IllustrationItemView()
            
            // 恢复截取下来的屏幕快照
            illuView.SetDrawingInfo(info, UIImage(data: data)!)
            itemCell.illustrationView = illuView
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            // Load header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DEQUEUE_HEADER_IDENTIFIER, for: indexPath)
            
            if let illuHeader = header as? IlluItemHeader {
                illuHeader.TypeTitle = IlluType[indexPath.section]
                return illuHeader
            }
            break
        case UICollectionView.elementKindSectionFooter:
            let emptyFoot = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DEQUEUE_EMPTY_IDENTIFIER, for: indexPath) as! IlluEmptyFooter
            emptyFoot.InitSubView(.LocalEmpty)
            return emptyFoot
        default:
            break
        }
        return UICollectionReusableView()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if FakeData[section].count == 0 {
            return CGSize(width: IlluGridView.frame.width, height: 150)
        }
        return CGSize(width: 0, height: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO - 处理点击事件，进入作品详情页面或者是重新编辑
        let (info, _) = FakeData[indexPath.section][indexPath.row]
        let id = info.DrawingID
        let historyURL = PersistenceManager.GetFileURL(.LocalWork, .DrawingHistory, id)
        let hasHistory = PersistenceManager.IfFileExists(historyURL)
        
        if hasHistory, let draftData = PersistenceManager.LoadLocalWorkDraftData(historyURL) {
            self.GoToDrawingView(draftData, info)
        }
    }
}
