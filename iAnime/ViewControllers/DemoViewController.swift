//
//  DemoViewController.swift
//  iAnime
//
//  Created by Zoom on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var horizontalSV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadFakeIlluData()
        // Do any additional setup after loading the view.
    }
    
    private func LoadFakeIlluData() {
        let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Name: "Zhengzeming", UploadDate: Date())
        
        let illu2 = Illustration(Image: UIImage(named: "Left-3")!, Name: "Huangpixuan", UploadDate: Date())
        
        let item1 = IllustrationItemView()
        item1.illustration = illu1
        
        let item2 = IllustrationItemView()
        item2.illustration = illu2
        
        
        horizontalSV.addArrangedSubview(item1)
        horizontalSV.addArrangedSubview(item2)
    }
}
