//
//  ViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var stackViewsContainer: ScrollStackContainerView!
    private var stackViews : [UIStackView] = []
    @IBOutlet weak var dimBackgroundView: UIView!
    @IBOutlet weak var iAnimeLogo: UIImageView!
    
    @IBOutlet weak var LoginAndRegisterContainer: FragmentViewContainer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyboard = self.storyboard {
            LoginAndRegisterContainer.AddViewController(storyboard.instantiateViewController(withIdentifier: "Login") as! FragmentViewController)
            LoginAndRegisterContainer.AddViewController(storyboard.instantiateViewController(withIdentifier: "Register") as! FragmentViewController)

        }
        
        
        
        stackViewsContainer.OnPlacedStackView = {
            views in
            self.stackViews = views
            let stackWidth = self.stackViewsContainer.EachStackViewWidth
            let left = views[0], center = views[1], right = views[2]
            
            for _ in 0..<2 {
                for i in 0...3 {
                    let image = UIImage(named: "Left-\(i)")
                    if let unwrappedImage = image {
                        let iv = self.CreareImageViewForScrollStackView(unwrappedImage, stackWidth)
                        let iv2 = self.CreareImageViewForScrollStackView(unwrappedImage, stackWidth)
                        left.addArrangedSubview(iv)
                        right.addArrangedSubview(iv2)
                    }
                }
            }
            
            for _ in 0..<2 {
                for i in (0...3).reversed() {
                    let image = UIImage(named: "Left-\(i)")
                    if let unwrappedImage = image {
                        let iv = self.CreareImageViewForScrollStackView(unwrappedImage, stackWidth)
                        center.addArrangedSubview(iv)
                    }
                }
            }
            
            self.BeginScrollImages()
        }
    }
    
    
    
    private func BeginScrollImages() {
        let animationList = InorderAnimation()
        animationList.AddAnimation(animation: ExecuteAnimation(Duration: 0.8, Delay:0, Options: .curveEaseInOut, WhenComplete: { _ in
            self.performSelector(inBackground: #selector(self.MoveStackViews), with: self)
        }, DoAnimation: {
            self.dimBackgroundView.alpha=0.6
        }))
        animationList.AddAnimation(animation: ExecuteAnimation(Duration: 0.3, Delay: 0.8, Options: .curveEaseInOut, WhenComplete: {
            _ in
            self.iAnimeLogo.removeFromSuperview()
            self.LoginAndRegisterContainer.PresentNewViewControllerWithAnimation(0)
        }
            , DoAnimation: {
                self.iAnimeLogo.alpha = 0
        }))
        
        animationList.Begin()
    }
    
    @objc private func MoveStackViews() {
        while true {
            DispatchQueue.main.sync {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.stackViews.forEach { view in
                    var yOffset : CGFloat = 0
                    if let firstImage = view.arrangedSubviews.first as? UIImageView, -view.frame.origin.y > firstImage.frame.size.height + 100 {
                        
                        firstImage.removeFromSuperview()
                        view.addArrangedSubview(firstImage)
                        yOffset = firstImage.frame.size.height + self.stackViewsContainer.spacingEachImage
                    }
                    
                    view.transform = view.transform.translatedBy(x: 0, y: -0.8 + yOffset)
                }
                CATransaction.commit()
            }
            usleep(16 * 1000)
        }
    }
    
    private func CreareImageViewForScrollStackView(_ image : UIImage, _ stackWidth : CGFloat) -> UIImageView {
        let iv = UIImageView()
        iv.image = image
        if image.size.width < image.size.height {
            
            // 对UIImageView进行等比拉伸放大
            iv.widthAnchor
                .constraint(equalToConstant: stackWidth)
                .isActive = true
            iv.heightAnchor
                .constraint(equalToConstant: CGFloat(stackWidth * (image.size.height / image.size.width)))
                .isActive = true
        }
        else {
            // 按照9/16截取之后再放大
            iv.widthAnchor
                .constraint(equalToConstant: stackWidth)
                .isActive = true
            iv.heightAnchor
                .constraint(equalToConstant: stackWidth * 16 / 9)
                .isActive = true
            iv.contentMode = .scaleAspectFill
        }
        return iv
    }
}

