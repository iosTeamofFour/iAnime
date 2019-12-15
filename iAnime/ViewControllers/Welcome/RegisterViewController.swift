//
//  RegisterViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class RegisterViewController: FragmentViewController,UITextFieldDelegate {
    
    @IBOutlet weak var account: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordAgain: UITextField!
    
    private var userServices : UserServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userServices = GetAppDelegate()._UserServices
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChangeTextFieldStyle()
        BindTextFieldDelegate()
        ClearInputFields(account, password, passwordAgain)
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
    
    
    @IBAction func Register(_ sender: UIButton) {
        let Phone = (account.text ?? "").trimmingCharacters(in: [" "])
        let Password = password.text ?? "", PasswordAgain = passwordAgain.text ?? ""
        if Password.elementsEqual(PasswordAgain) {
            let (container,_) = ShowLoadingIndicator()
            userServices.Register(Phone: Phone, Password: Password, HandleSuccess: {
                code in
                container.removeFromSuperview()
                self.AllowDismissWhenClickOutside()
                switch code {
                case 0:
                    self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "注册成功", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: { _ in
                        self.BackToLogin(sender)
                    })),animated: true, completion: nil)
                case -1:
                    self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "该用户已经被注册", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: nil)),animated: true, completion: nil)
                default:
                    self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "服务器端出现未知错误", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: nil)),animated: true, completion: nil)
                }
            }, HandleFailed: {
                container.removeFromSuperview()
                self.AllowDismissWhenClickOutside()
                self.present(UIAlertController.MakeSingleSelectionAlertDialog("提示", ControllerMsg: "服务器开小差了，请稍后再尝试注册", SingleAction: UIAlertAction(title: "好", style: .cancel, handler: nil)),animated: true, completion: nil)
            })
        }
        else {
            // Make a hint that two password are not equal.
            let ac = UIAlertController.MakeAlertDialog("提示", "两次密码输入不一致", [
                UIAlertAction(title: "好", style: .cancel, handler: nil)
                ])
            present(ac, animated: true, completion: {
                // Help the user to clear the fucking wrong password.
                self.password.text = ""
                self.passwordAgain.text = ""
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func ChangeTextFieldStyle() {
        [account,password,passwordAgain].forEach {
            view in
            if let uview = view {
                uview.ChangeBorder(.roundedRect,4,UIColor.white.cgColor,1.5)
                uview.ChangePlaceHolderTextColor(UIColor.white.cgColor)
            }
        }
    }
    private func BindTextFieldDelegate() {
        [account,password,passwordAgain].forEach {
            field in field?.delegate = self
        }
    }
    
    @IBAction func BackToLogin(_ sender: UIButton) {
        fragmentContainer?.PresentNewViewControllerWithAnimation(0)
    }
}
