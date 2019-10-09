//
//  ViewControllerHelper.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit


public extension UIViewController {
    public func ToggleVisibleForNavigationItem(_ visible : Bool) {
        self.navigationController?.setNavigationBarHidden(!visible, animated: false)
    }
    
    public func ToggleVisibleForTabBarItem(_ visible : Bool) {
        self.tabBarController?.tabBar.isHidden = !visible
    }
    public func GoToExternalStoryboardWithInitialVC(_ storyboardIdentifier : String, _ backKey : String?) -> UIViewController? {
        let next = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let vc = next.instantiateInitialViewController()
        guard let _vc = vc else {
            print("View Controller with identifier \(storyboardIdentifier) not found!")
            return nil
        }
        navigationController?.pushViewController(_vc, animated: true)
        if let _backKey = backKey {
            _vc.navigationController?.navigationBar.topItem?.backBarButtonItem =  UIBarButtonItem(title: _backKey, style: .plain , target: nil, action: nil)
        }
        return vc
    }
    
    public func GoToExternalStoryboardWithVCSpecified(_ storyboardIdentifier : String, vcIdentifier : String, _ backKey : String?) -> UIViewController {
        let next = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: vcIdentifier)
        navigationController?.pushViewController(vc, animated: true)
        if let _backKey = backKey {
            vc.navigationController?.navigationBar.topItem?.backBarButtonItem =  UIBarButtonItem(title: _backKey, style: .plain , target: nil, action: nil)
        }
        return vc
    }
}
