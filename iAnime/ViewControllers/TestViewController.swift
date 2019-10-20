//
//  TestViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var button: MultistateButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let states : [ButtonState] = [
            ButtonState("关注", UIImage(named: "AddNoCircle"),nil,UIColor.init(red: 0, green: 118/255, blue: 1, alpha: 1), OnBtnClicked),
            ButtonState("已关注",UIImage(named: "Checkmark"), nil, UIColor.gray, OnBtnClicked)
        ]
        
        button.AddStates(states)
    }
    
    
    private func OnBtnClicked(_ sender : MultistateButton) {
        sender.NextState((sender.CurrentState + 1) % sender.ButtonState.count)
    }
    
}
