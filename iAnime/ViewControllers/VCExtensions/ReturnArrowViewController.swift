//
//  ReturnArrowViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class ReturnArrowViewController: UIViewController {
    
    private(set) var ArrowImage : UIImageView!
    private(set) var ClickGestureRecognizer : UITapGestureRecognizer!
    
    @IBInspectable var ArrowImageName : String = "ArrowLeftWithShadow"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitBackKey()
    }
    
    private func InitBackKey() {
        ArrowImage = UIImageView(image: UIImage(named: ArrowImageName)!)
        ArrowImage.translatesAutoresizingMaskIntoConstraints = false
        ArrowImage.isUserInteractionEnabled = true
        ArrowImage.contentMode = .scaleAspectFit
        
        view.addSubview(ArrowImage)
        ArrowImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).Activate()
        
        ArrowImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).Activate()
        ArrowImage.widthAnchor.constraint(equalToConstant: 36).Activate()
        ArrowImage.heightAnchor.constraint(equalToConstant: 36).Activate()
        
        ClickGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OnClickedReturnKey))
        
        ArrowImage.addGestureRecognizer(ClickGestureRecognizer)
    }
    
    @objc private func OnClickedReturnKey(_ sender:UITapGestureRecognizer) {
        
        if let naviController = navigationController {
            naviController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
}
