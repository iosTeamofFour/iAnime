
//  PersonViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/13.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PersonViewController: ReturnArrowViewController {
    
    

    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var FollowerCount: UILabel!
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var Signature: UILabel!

    @IBOutlet weak var TimelineContainer: UIStackView!
    

    
    @IBOutlet weak var FollowUserButton: MultistateButton!
    
    var FakeData : [Pair<String,[String]>] = [
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
    
}
