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
    
    private var PinchBeganOrigin : CGPoint = CGPoint.zero
    private var ScaleBeginRatio : CGFloat = 0
    
    private var TotalOffsetX : CGFloat = 0
    private var TotalOffsetY : CGFloat = 0
    
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
        
        if sender.state == .began {
            PinchBeganOrigin = sender.location(in: imageView)
            print("初始位置:\(PinchBeganOrigin)")
        }
        
        if sender.state == .changed {
            
            // 获取双指缩放中心点:
            
            if sender.numberOfTouches == 2 {
                let first = sender.location(ofTouch: 0, in: imageView)
                let second = sender.location(ofTouch: 1, in: imageView)
                
                let ratioX = PinchBeganOrigin.x / imageView.bounds.size.width
                let ratioY = PinchBeganOrigin.y / imageView.bounds.size.height
                
                let newWidth = imageView.frame.width * sender.scale
                let newHeight = imageView.frame.height * sender.scale
                
                let offsetX = (newWidth - imageView.frame.width) * (0.5 - ratioX)
                let offsetY = (newHeight - imageView.frame.height) * (0.5 - ratioY)
                
                TotalOffsetX += offsetX
                TotalOffsetY += offsetY
                
                imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
                imageView.transform = imageView.transform.translatedBy(x: offsetX, y: offsetY)
            }
            

        }
        
        if sender.state == .ended {
            print("\(TotalOffsetX)   \(TotalOffsetY)")
            TotalOffsetY = 0
            TotalOffsetX = 0
        }
        sender.scale = 1
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
