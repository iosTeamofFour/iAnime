//
//  PersonViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/13.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    @IBOutlet weak var backgroundbackView: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var signature: UILabel!
    @IBOutlet weak var followerNum: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var attention: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let person1=Person(backgroundImage: UIImage(named: "Left-7")!,avatar:UIImage(named:"SampleAvatar")!,nickName:"zoom",signature:"天天打码",followerNum:2,followingNum:22)
        
        
        initInfo(person1)
        avatar.SetCircleBorder()
    }
    func initInfo(_ person:Person){
        backgroundbackView.image=person.backgroundImage
        avatar.image=person.avatar
        nickName.text=person.nickName
        signature.text=person.signature
        followerNum.text=String(person.followerNum)
        followingNum.text=String(person.followingNum)
        
        AdjustTextColor()
    }
    
    func AdjustTextColor() {
        let colorForNickName = UIUtils.DetectTextColorWithBG(nickName, backgroundbackView)
        let colorForSignature = UIUtils.DetectTextColorWithBG(signature, backgroundbackView)
        
        nickName.textColor = colorForNickName ? UIColor.white : UIColor.black
        signature.textColor = colorForSignature ? UIColor.white : UIColor.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIUtils.DetectStatusBarColor(view, backgroundbackView) ? .lightContent : .default
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
