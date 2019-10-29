//
//  OuterTestViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/23.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class OuterTestViewController: UIViewController {

    
    private var OneAnchorPoint : UIBezierPath?
    
    @IBOutlet weak var TestBorderButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .system)
        button.setTitle("xxx", for: .normal)
        button.frame = CGRect(x: 50, y: 50, width: 60, height: 30)
        view.addSubview(button)
    }
    
    
    private func ShowPopover(_ sender: UIButton) {
        if let storyboard = self.storyboard, let vc = storyboard.instantiateViewController(withIdentifier: "TestColorPicker") as? TestViewController {
            vc.modalPresentationStyle = .popover
            vc.popoverPresentationController?.delegate = vc
            vc.popoverPresentationController?.sourceView = sender
            vc.popoverPresentationController?.sourceRect = sender.bounds
            vc.popoverPresentationController?.backgroundColor = vc.view.backgroundColor
            vc.preferredContentSize = CGSize(width: 320, height: 460)
            present(vc, animated: true, completion: nil)
        }
    }
    
}
