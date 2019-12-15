//
//  HomeViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var HomeBackgroundImage: UIImageView!
    @IBOutlet weak var UserAvatarImage: UIImageView!
    
    @IBOutlet weak var SignTextField: UITextField!
    @IBOutlet weak var UserNickName: UILabel!
    @IBOutlet weak var UserLevel: UILabel!

    private var userServices : UserServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignTextField.delegate = self
        userServices = GetAppDelegate()._UserServices
        LoadUserProfile()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ToggleVisibleForNavigationItem(false)
    }
    private func LoadUserProfile() {
        userServices.LoadSelfProfile({
            json in
            self.UserNickName.text = self.userServices.CurrentUserProfile?.NickName
            self.SignTextField.text = self.userServices.CurrentUserProfile?.Signature
        }, { err in
            self.present(UIAlertController.MakeSingleSelectionAlertDialog(
                        "提示",
                        ControllerMsg: "获取个人信息失败, 检查网络连接",
                        SingleAction: UIAlertAction.Well(nil)),
                        animated: true,
                        completion: nil)
        })
        
        request(ApiCollection.Avatar, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth.AuthHeader).responseImage(completionHandler: {
            resp in
            self.UserAvatarImage.image = resp.result.value
        })
        
        request(ApiCollection.BackgroundPhoto, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth.AuthHeader).responseImage(completionHandler: {
            resp in
            self.HomeBackgroundImage.image = resp.result.value
        })
    }
    
    
    
    
    
    
    @IBAction func ChangeBackgroundImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController.MakeAlertSheet("主页背景", nil, [
            UIAlertAction(title: "更改个人主页背景", style: .default, handler: {
                _ in
                self.present(
                    UIAlertController.MakeAlertDialog("提示", "此功能仍未完成!", [
                        UIAlertAction(title: "好", style: .cancel, handler: nil)
                        ]), animated: true, completion: nil)
            }),
            UIAlertAction(title: "取消", style: .cancel, handler: nil)
            ])
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ChangeAvatar(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController.MakeAlertSheet("头像", nil,[
            UIAlertAction(title: "预览", style: .default, handler: {
                _ in
                print("Preview")
            }),
            UIAlertAction(title: "修改个人头像", style: .default, handler: {
                _ in
                print("点击修改Avatar")
            }),
            UIAlertAction(title: "取消", style: .cancel, handler: nil)])
        
        present(alert, animated: true, completion: nil)
    }
}
