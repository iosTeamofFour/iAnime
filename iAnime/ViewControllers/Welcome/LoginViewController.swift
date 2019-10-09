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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
