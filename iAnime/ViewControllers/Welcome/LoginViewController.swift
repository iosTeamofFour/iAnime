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
        userServices = GetAppDelegate()._UserServices
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChangeTextFieldStyle()
        BindTextFieldDelegate()
        ClearInputFields(UserNameField, PasswordField)
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
        let (container,_) = ShowLoadingIndicator()
        userServices.Login(Phone: Phone, Password: Passwd, HandleSuccess: {

            code in
            container.removeFromSuperview()
            self.AllowDismissWhenClickOutside()
            switch code {
            case 0:
                self.performSegue(withIdentifier: "GoToIndex", sender: nil)
            case -1:
                self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "用户名或密码错误", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: nil)),animated: true, completion: nil)
            default:
                self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "服务器端出现未知错误", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: nil)),animated: true, completion: nil)
            }
        }, HandleFailed: {
            code in
            container.removeFromSuperview()
            self.AllowDismissWhenClickOutside()
            self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "服务器开小差了，请稍后再尝试登陆", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: nil)),animated: true, completion: nil)
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
