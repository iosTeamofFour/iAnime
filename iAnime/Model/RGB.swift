//
//  RGB.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/22.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit


struct RGB : Equatable {
    var R : CGFloat
    var G : CGFloat
    var B : CGFloat
    
    public func RankedRGB() -> [(offset: Int, element: CGFloat)] {
        return [R,G,B].enumerated().sorted(by: {(a,b) in a.element > b.element })
    }
    
    var ArrayShape : [CGFloat] {
        get {
            return [R,G,B]
        }
    }
    
    var AsUIColor : UIColor {
        get {
            return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1)
        }
    }
    
    static func ==(_ lhs : RGB, _ rhs : RGB) -> Bool {
        return lhs.R == rhs.R && lhs.G == rhs.G && lhs.B == rhs.B
    }
}
