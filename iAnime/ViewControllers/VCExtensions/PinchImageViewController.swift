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
    
    private var imageViewOriginalSize : CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageViewOriginalSize = imageView.GetCGSizeInAspectFit()
        print("图片本体应该存在的大小: \(imageViewOriginalSize!)")
    }
    @IBAction func OnImageViewPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        else if sender.state == .ended {
            var scaleX = imageView.transform.a
            var scaleY = imageView.transform.d
            
            if scaleX > 3 {
                scaleX = 3
                scaleY = 3
            }
            else if scaleX < 0.4 {
                scaleX = 1
                scaleY = 1
            }
            
            var matrix = imageView.transform
            matrix.a = scaleX
            matrix.d = scaleY
            if sender.numberOfTouches == 2 {
                let first = sender.location(ofTouch: 0, in: view)
                let second = sender.location(ofTouch: 1, in: view)
                let center = CGPoint(x: (first.x + second.x)/2, y: (first.y+second.y)/2)
                let offset = CGPoint(x: view.center.x - center.x, y: view.center.y - center.y)
                matrix = matrix.translatedBy(x: offset.x, y: offset.y)
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.transform = matrix
            })
        }
    }
    
    
    @IBAction func OnImageViewPan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let trans = sender.translation(in: imageView)
            imageView.transform = imageView.transform.translatedBy(x: trans.x, y: trans.y)
            sender.setTranslation(CGPoint.zero, in: imageView)
        }
        else if sender.state == .ended {
            let xOffset = imageView.frame.origin.x
            let ivWidth = imageView.frame.width
            if xOffset + ivWidth < view.frame.width/2 {
                print("Next Image")
            }
            else if xOffset > view.frame.width/2 {
                print("Last Image")
            }
        }
    }
    

}
