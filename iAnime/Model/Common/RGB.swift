//
//  RGB.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/22.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit


class RGB : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Int(R), forKey: "R")
        aCoder.encode(Int(G), forKey: "G")
        aCoder.encode(Int(B), forKey: "B")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let r = aDecoder.decodeInteger(forKey: "R")
        let g = aDecoder.decodeInteger(forKey: "G")
        let b = aDecoder.decodeInteger(forKey: "B")
        
        R = CGFloat(r)
        G = CGFloat(g)
        B = CGFloat(b)
    }
    
    
    var R : CGFloat
    var G : CGFloat
    var B : CGFloat

    init(R:CGFloat,G:CGFloat,B:CGFloat) {
        self.R = R
        self.G = G
        self.B = B
    }
    
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
