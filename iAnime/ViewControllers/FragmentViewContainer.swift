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

open class FragmentViewController : UIViewController {
    private(set) var FirstInsertedToContainer = true
    private(set) var fragmentContainer : FragmentViewContainer?
    func OnRegistered(_ fragmentContainer : FragmentViewContainer) -> Void {
        self.fragmentContainer = fragmentContainer
    }
    
    func OnLoadFrameInfoFromContainer() {
        FirstInsertedToContainer = false
        return
    }
}


class FragmentViewContainer: UIView {
    
    private(set) var fragments : [FragmentViewController] = []
    
    private(set) var CurrentPresentViewController : Int = 0
    
    private var CurrentPresentView : UIView? = nil
    
    
    func AddViewController(_ controller : FragmentViewController) {
        fragments.append(controller)
        controller.OnRegistered(self)
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
            vcView.translatesAutoresizingMaskIntoConstraints = false
            vcView.frame.size = frame.size
            if setAlphaToZero {
                vcView.alpha = 0
            }
            addSubview(vcView)
            vcView.pin(to: self)
            layoutIfNeeded()
            fragments[index].OnLoadFrameInfoFromContainer()
            
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
