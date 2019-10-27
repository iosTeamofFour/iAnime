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
    public func GetCGSizeInAspectFit(_ parentViewSize : CGSize,_ contentImage : UIImage? = nil) -> CGSize? {
        let IvFrameSize = parentViewSize
        let ImageSize = (contentImage ?? image!).size
        
        let ImageWHRatio = ImageSize.width / ImageSize.height
        
        var FinalWidth : CGFloat = 0
        var FinalHeight : CGFloat = 0
        // 涵盖两种情况, 一种是原图width > height, 另一种是虽然原图width < height, 但是如果按照div的frame.size.height缩放得到的width又会大过frame.size.width
        if ImageSize.width >= ImageSize.height || IvFrameSize.width < IvFrameSize.height * (ImageWHRatio)  {
            FinalWidth = IvFrameSize.width
            FinalHeight = FinalWidth * (1 / ImageWHRatio)
            return CGSize(width: FinalWidth, height: FinalHeight)
        }
        else {
            FinalHeight = IvFrameSize.height
            FinalWidth = FinalHeight * (ImageWHRatio)
            return CGSize(width: FinalWidth, height: FinalHeight)
        }
    }
    
    
    public func GetCGSizeInAspectFill(_ parentViewSize : CGSize, _ contentImage : UIImage? = nil) -> CGSize? {
        // 这种情况下直接按照短边放大即可
        if image == nil {
            return nil
        }
        let IvFrameSize = parentViewSize
        let ImageSize = (contentImage ?? image!).size
        let ImageWHRatio = ImageSize.width / ImageSize.height
        
        if ImageSize.width >= ImageSize.height || IvFrameSize.width < IvFrameSize.height * (ImageWHRatio) {
            return CGSize(width: IvFrameSize.height * (ImageWHRatio), height: IvFrameSize.height)
        }
        
        return IvFrameSize
    }
}

public extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}

public extension CGPoint {
    public static func MidPoint(_ lhs : CGPoint, _ rhs : CGPoint) -> CGPoint {
        return CGPoint(x: (lhs.x + rhs.x)/2, y: (lhs.y + rhs.y)/2)
    }
    
    public func distance(_ with : CGPoint) -> CGFloat {
        return CGFloat(sqrt(Double(pow(x * with.x, 2) + pow(y * with.y, 2))))
    }
}

