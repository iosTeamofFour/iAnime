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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
