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
