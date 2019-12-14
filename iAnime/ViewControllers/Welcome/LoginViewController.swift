//
//  LoginViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class LoginViewController: FragmentViewController, UITextFieldDelegate {

    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    private var userServices : UserServices!

    override func viewDidLoad() {
        super.viewDidLoad()
        userServices = GetAppDelegate().userServices
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChangeTextFieldStyle()
        BindTextFieldDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    @IBAction func Login(_ sender: UIButton) {
        let Phone = UserNameField.text ?? ""
        let Passwd = PasswordField.text ?? ""
        userServices.Login(Phone: Phone, Password: Passwd, HandleSuccess: {
            code in
            switch code {
            case 0:
                self.performSegue(withIdentifier: "GoToIndex", sender: nil)
            case -1:
                print("用户名或密码错误.")
            default:
                print("未知错误")
            }
        }, HandleFailed: {
            print("目前暂时不允许登录.")
        })
    }
    
    
    
    
    
    
    // ===== 美化输入框界面 ======
    
    private func ChangeTextFieldStyle() {
        [UserNameField,PasswordField].forEach {
            view in
            if let uview = view {
                uview.ChangeBorder(.roundedRect,4,UIColor.white.cgColor,1.5)
                uview.ChangePlaceHolderTextColor(UIColor.white.cgColor)
            }
        }
    }
    
    private func BindTextFieldDelegate() {
        [UserNameField, PasswordField].forEach {
            field in field?.delegate = self
        }
    }
    @IBAction func JumpToRegister(_ sender: UIButton) {
        fragmentContainer?.PresentNewViewControllerWithAnimation(1)
    }
}
