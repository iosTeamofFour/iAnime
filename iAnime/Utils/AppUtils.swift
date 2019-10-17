//
//  AppUtils.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/17.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit


public extension UIAlertController {
    
    public static func MakeAlertDialog(_ controllerTitle : String, _ controllerMsg : String?,_ actions : [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: controllerTitle, message: controllerMsg, preferredStyle: .alert)
        actions.forEach { action in alertController.addAction(action) }
        return alertController
    }
    
    public static func MakeAlertSheet(_ controllerTitle : String, _ controllerMsg : String?,_ actions : [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: controllerTitle, message: controllerMsg, preferredStyle: .actionSheet)
        actions.forEach { action in alertController.addAction(action) }
        return alertController
    }
}

public extension UIImageView {
    public func GetCGSizeInAspectFit() -> CGSize? {
        if image == nil {
            return nil
        }
        let IvFrameSize = frame.size
        let ImageSize = image!.size
        
        let ImageWHRatio = ImageSize.width / ImageSize.height
        
        var FinalWidth : CGFloat = 0
        var FinalHeight : CGFloat = 0
        
        if ImageSize.width >= ImageSize.height {
            FinalWidth = IvFrameSize.width
            FinalHeight = FinalWidth * (1 / ImageWHRatio)
            return CGSize(width: FinalWidth, height: FinalHeight)
        }
        else {
            if IvFrameSize.width < IvFrameSize.height * (ImageWHRatio) {
                // 还是按照width来缩放
            }
            else {
                
            }
        }
    }
}
