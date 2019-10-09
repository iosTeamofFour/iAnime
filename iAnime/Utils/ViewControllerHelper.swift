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
    public func GoToExternalStoryboardWithInitialVC(_ storyboardIdentifier : String, _ backKey : String) -> UIViewController? {
        let next = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let vc = next.instantiateInitialViewController()
        if let _vc = vc {
            navigationController?.pushViewController(_vc, animated: true)
            _vc.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = backKey
            return _vc
        }
        return nil
    }
    
    public func GoToExternalStoryboardWithVCSpecified(_ storyboardIdentifier : String, vcIdentifier : String, _ backKey : String) -> UIViewController {
        let next = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: vcIdentifier)
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = backKey
        return vc
    }
}
