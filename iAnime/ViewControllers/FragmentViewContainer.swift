//
//  FragmentViewContainer.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

enum PresentNewFragmentAnimationType {
    case FadeInOut
}

class FragmentViewContainer: UIView {
    
    private(set) var fragments : [UIViewController] = []
    
    private(set) var CurrentPresentViewController : Int = 0
    
    private var CurrentPresentView : UIView? = nil
    
    func AddViewController(_ controller : UIViewController) {
        fragments.append(controller)
    }
    
    func RemoveViewControllerAt(_ index : Int) {
        if !fragments.InRange(index) {
            return
        }
        fragments.remove(at: index)
    }
    
    func PresentNewViewController(_ index : Int, _ setAlphaToZero : Bool = false) {
        CurrentPresentView?.removeFromSuperview()
        if fragments.InRange(index) {
            let vcView = fragments[index].view!
            if setAlphaToZero {
                vcView.alpha = 0
            }
            self.addSubview(vcView)
            vcView.pin(to: self)
            CurrentPresentView = vcView
            CurrentPresentViewController = index
        }
        else {
            fatalError("Cannot present view controller \(index) out of range!")
        }
    }
    
    func PresentNewViewControllerWithAnimation(_ index : Int) {
        let animationList = InorderAnimation()
        if let currentView = CurrentPresentView {
            animationList.AddAnimation(animation: ExecuteAnimation(Duration: 0.3, Delay: 0, Options: .curveEaseInOut, WhenComplete: { _ in
                currentView.removeFromSuperview()
                self.PresentNewViewController(index, true)
            }, DoAnimation: {
                currentView.alpha = 0
            }))
        }
        else {
            self.PresentNewViewController(index, true)
        }
        animationList.AddAnimation(animation: ExecuteAnimation(Duration: 0.3, Delay: 0, Options: .curveEaseInOut, WhenComplete: nil, DoAnimation: {
            self.CurrentPresentView?.alpha = 1
        }))
        
        animationList.Begin()
    }
}
