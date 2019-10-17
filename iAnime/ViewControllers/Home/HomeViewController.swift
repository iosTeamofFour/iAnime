//
//  HomeViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var HomeBackgroundImage: UIImageView!
    @IBOutlet weak var UserAvatarImage: UIImageView!
    
    @IBOutlet weak var SignTextField: UITextField!
    @IBOutlet weak var UserNickName: UILabel!
    @IBOutlet weak var UserLevel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        SignTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIUtils.DetectStatusBarColor(view, HomeBackgroundImage) ? .lightContent : .default
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
    }
    
    
    @IBAction func ChangeBackgroundImage(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "主页背景", message: nil, preferredStyle: .actionSheet)
        
        let changeBackgroundAction = UIAlertAction(title: "更改主页背景", style: .default, handler: {
            
        })
    }
    
    @IBAction func ChangeAvatar(_ sender: UITapGestureRecognizer) {
        
        
    }
    
}
