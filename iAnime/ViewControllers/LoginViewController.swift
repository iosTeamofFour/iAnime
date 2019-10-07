//
//  LoginViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChangeTextFieldStyle()
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
                uview.borderStyle = .roundedRect
                uview.layer.cornerRadius = 4
                uview.layer.borderColor = UIColor.white.cgColor
                uview.layer.borderWidth = 1.5
                uview.attributedPlaceholder = NSAttributedString(string: uview.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
            }
        }
    }
    
    private func BindTextFieldDelegate() {
        [UserNameField, PasswordField].forEach {
            field in field?.delegate = self
        }
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
