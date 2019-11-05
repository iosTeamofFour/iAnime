//
//  Vector2.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/24.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit


public class Vector2 : NSObject,NSCoding {
    var x : CGFloat
    var y : CGFloat
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(Float(x), forKey: "x")
        aCoder.encode(Float(y), forKey: "y")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        x = CGFloat(aDecoder.decodeFloat(forKey: "x"))
        y = CGFloat(aDecoder.decodeFloat(forKey: "y"))
    }
    
    public init(x : CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    var length : CGFloat {
        get {
            return CGFloat(sqrtf(Float(x * x + y * y)))
        }
    }
    
    func AsCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
    
    var normalize : Vector2 {
        get {
            let X = self.x / self.length
            let Y = self.y / self.length
            return Vector2(x: X, y: Y)
        }
    }
    
    static func - (_ lhs : Vector2, _ rhs : Vector2) -> Vector2{
        return Vector2(x: lhs.x - rhs.x , y: lhs.y - rhs.y)
    }
    static func + (_ lhs : Vector2, _ rhs : Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x , y: lhs.y + rhs.y)
    }
    
    static func * (_ lhs : Vector2, _ rhs : Vector2) -> Vector2 {
        return Vector2(x: lhs.x * rhs.x , y: lhs.y * rhs.y)
    }
    
    func multiply(_ time: CGFloat) -> Vector2 {
        return Vector2(x: x * time , y: y * time)
    }
    
    func perp() -> Vector2 {
        if y == 0 {
            return Vector2(x: 0, y: 1)
        }
        return Vector2(x: x, y: -(x * x) / y).normalize
    }
    
    static func distance(_ lhs : Vector2, _ rhs : Vector2) -> CGFloat {
        return CGFloat(sqrt(Double(pow(lhs.x - rhs.x, 2) + pow(lhs.y - rhs.y, 2))))
    }
}

public extension CGPoint {
    public func AsVector2() -> Vector2 {
        return Vector2(x: self.x, y: self.y)
    }
}
