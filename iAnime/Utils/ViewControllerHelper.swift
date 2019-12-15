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
        if !visible {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
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
        _vc.hidesBottomBarWhenPushed = true // 隐藏上一个View的TabBar（如果有）
        navigationController?.pushViewController(_vc, animated: true)
        if let _backKey = backKey {
            _vc.navigationController?.navigationBar.topItem?.backBarButtonItem =  UIBarButtonItem(title: _backKey, style: .plain , target: nil, action: nil)
        }
        return vc
    }
    
    public func GoToExternalStoryboardWithVCSpecified(_ storyboardIdentifier : String, vcIdentifier : String, _ backKey : String?) -> UIViewController {
        let next = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: vcIdentifier)
        vc.hidesBottomBarWhenPushed = true // 隐藏上一个View的TabBar（如果有）
        navigationController?.pushViewController(vc, animated: true)
        if let _backKey = backKey {
            vc.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: _backKey, style: .plain , target: nil, action: nil)
        }
        return vc
    }
    
    
    public func PushVCToCurrentNC(vcName : String, backItem : String?) -> UIViewController? {
        guard let sb = storyboard, let naviController = navigationController else {
            print("无法加载指定的ViewController \(vcName) 到当前ViewController \(self)的NavigationController中。")
            return nil
        }
        hidesBottomBarWhenPushed = true
        let vc = sb.instantiateViewController(withIdentifier: vcName)
        naviController.pushViewController(vc, animated: true)
        
        if let _backItem = backItem {
            vc.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: _backItem, style: .plain , target: nil, action: nil)
        }
        return vc
    }
    
    public func PreventDismissWhenClickOutside() {
        isModalInPopover = true
    }
    
    public func AllowDismissWhenClickOutside() {
        isModalInPopover = false
    }
    
    public func ShowLoadingIndicator() -> (UIView, UIActivityIndicatorView) {
        PreventDismissWhenClickOutside()
        return view.ShowLoadingIndicator()
    }
    
    public func ClearInputFields(_ items : UITextField...) {
        items.forEach({ tf in tf.text = "" })
    }
}
