//
//  HomeViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var HomeBackgroundImage: UIImageView!
    @IBOutlet weak var UserAvatarImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        
        UserAvatarImage.SetCircleBorder()
        AdjustHomepageBackgroundImage()
    }
    
    private func AdjustHomepageBackgroundImage() {
        
        
        
        // 按屏幕的高等比缩放
        let ViewHeight = view.frame.height
        HomeBackgroundImage.addConstraint(NSLayoutConstraint(item: HomeBackgroundImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: ViewHeight / 3))
        
        HomeBackgroundImage.contentMode = .scaleAspectFill
        HomeBackgroundImage.clipsToBounds = true
        print("设置图片高为 \(ViewHeight/3)")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
