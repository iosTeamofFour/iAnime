//
//  PinchImageViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class PinchImageViewController: UIViewController {

   var imageView: UIImageView!
    
    @IBOutlet weak var scroller: UIScrollView!
    
    private var imageViewOriginalSize : CGSize?
    
    private var PinchBeganOrigin : CGPoint = CGPoint.zero
    private var ScaleBeginRatio : CGFloat = 0
    
    private var TotalOffsetX : CGFloat = 0
    private var TotalOffsetY : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "Left-4")!
        imageView = UIImageView()
        imageView.image = image
        imageView.isUserInteractionEnabled = true

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(OnImageViewPinch(_:)))
        imageView.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(OnImageViewPan(_:)))
        imageView.addGestureRecognizer(pan)
        
        imageViewOriginalSize = imageView.GetCGSizeInAspectFit(view.frame.size)
        
        
        // 定位imageView
        
        scroller.addSubview(imageView)
        
        let y = (view.frame.size.height - imageViewOriginalSize!.height)/2
        imageView.frame = CGRect(x: 0, y: y, width: imageViewOriginalSize!.width, height: imageViewOriginalSize!.height)
        
        
        
    }
    
    @objc func OnImageViewPinch(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            var centerPoint = sender.location(in: imageView)
            
            
            let ivBounds = imageView.bounds
            
            centerPoint.x -= ivBounds.midX
            centerPoint.y -= ivBounds.midY
            
            var matrix = imageView.transform
            
            matrix = matrix.translatedBy(x: centerPoint.x, y: centerPoint.y)
            matrix = matrix.scaledBy(x: sender.scale, y: sender.scale)
            matrix = matrix.translatedBy(x: -centerPoint.x, y: -centerPoint.y)
            
            imageView.transform = matrix
        }
        
        sender.scale = 1
    }
    
    @objc func OnImageViewPan(_ sender: UIPanGestureRecognizer) {
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
