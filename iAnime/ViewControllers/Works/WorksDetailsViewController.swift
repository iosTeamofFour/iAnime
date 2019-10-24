//
//  WorksDetailsViewController.swift
//  iAnime
//
//  Created by Zoom on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class WorksDetailsViewController: ReturnArrowViewController {
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var AuthorID: UILabel!
    @IBOutlet weak var Description: UILabel!
   
    @IBAction func SearchTag(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ScrollView.contentSize=CGSize.init(width: 375, height: 800)
    }
    func initView()
    {
        let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Avatar:UIImage(named: "SampleAvatar")!,AuthorName:"zoom", Name: "sample",AuthorId:"100",Id:"110", UploadDate: Date(),Description:"诶我也不饿觉委屈就委屈非让我减肥认为弗兰克黑色风格和法国文化氛围分阿拉维减肥啊师傅却忘了带我回到凤凰网色")
        Image.image=illu1.Image
        Name.text=illu1.Name
        ID.text=illu1.Id
        Avatar.image=illu1.Avatar
        Avatar.SetCircleBorder()
        AuthorID.text=illu1.AuthorId
        Description.text=illu1.Description
    }
    
    
}
