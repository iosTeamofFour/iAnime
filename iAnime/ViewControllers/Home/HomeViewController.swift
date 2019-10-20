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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        ToggleVisibleForNavigationItem(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ToggleVisibleForNavigationItem(false)
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
