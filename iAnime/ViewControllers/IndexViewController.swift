//
//  IndexViewController.swift
//  iAnime
//
//  Created by Zoom on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {
   
    @IBOutlet weak var MyIlluGrid: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyIlluGrid.OnPlacedGrid = {
            grid in
            self.LoadFakeIllustration()
            self.LoadFakeIllustration()
            self.LoadFakeIllustration()
        }
    }
    
    private func LoadFakeIllustration() {
        let illu1 = Illustration(Image: UIImage(named: "Left-2")!, Name: "Zhengzeming", UploadDate: Date())
        
        let illu2 = Illustration(Image: UIImage(named: "Left-3")!, Name: "Huangpixuan", UploadDate: Date())
        
        let item1 = IllustrationItemView()
        item1.illustration = illu1
        
        let item2 = IllustrationItemView()
        item2.illustration = illu2
        
        MyIlluGrid.AddItem(item1)
        MyIlluGrid.AddItem(item2)
    }

}
