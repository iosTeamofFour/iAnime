//
//  PinchImageViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PinchImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func OnImageViewPinch(_ sender: UIPinchGestureRecognizer) {
    }
    
    
    @IBAction func OnImageViewPan(_ sender: UIPanGestureRecognizer) {
        
    }
}
