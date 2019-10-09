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
    
    // Hide navigation bar.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToggleVisibleForNavigationItem(false)
        ToggleVisibleForTabBarItem(true)
    }
    
    // Reset navigation bar.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ToggleVisibleForNavigationItem(true)
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
    
    
    @IBAction func GoToSettings(_ sender: RightImageButton) {
        GoToExternalStoryboardWithInitialVC("Settings", "返回")?.ToggleVisibleForTabBarItem(false)
    }
}
