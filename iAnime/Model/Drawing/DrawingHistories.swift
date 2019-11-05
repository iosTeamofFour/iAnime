//
//  DrawingHistories.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit



class ColorHintPair : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(vector, forKey: "vector")
        aCoder.encode(hint, forKey: "hint")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let _vec = aDecoder.decodeObject(forKey: "vector") as? Vector2 else {
            return nil
        }
        
        guard let _hint = aDecoder.decodeObject(forKey: "hint") as? ColorHint else {
            return nil
        }
        
        vector = _vec
        hint = _hint
    }
    
    static func ConvertDicToPair(_ dic : Dictionary<Vector2, ColorHint>) -> [ColorHintPair] {
        return dic.map { (k,v) in ColorHintPair(vector: k, hint: v)}
    }
    
    var vector : Vector2
    var hint : ColorHint
    
    init(vector : Vector2, hint : ColorHint) {
        self.vector = vector
        self.hint = hint
    }
}


class ColorAnchorPair : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(vector, forKey: "vector")
        aCoder.encode(anchor, forKey: "anchor")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let _vec = aDecoder.decodeObject(forKey: "vector") as? Vector2 else {
            return nil
        }
        
        guard let _anchor = aDecoder.decodeObject(forKey: "anchor") as? ColorAnchor else {
            return nil
        }
        
        vector = _vec
        anchor = _anchor
    }
    
    var vector : Vector2
    var anchor : ColorAnchor
}

class DrawingHistory : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ControlPoints, forKey: "ControlPoints")
        aCoder.encode(Forces, forKey: "Forces")
        aCoder.encode(TouchingMode, forKey: "TouchingMode")
        aCoder.encode(UsedColor, forKey: "UsedColor")
        aCoder.encode(UsedPenLineWidth, forKey: "UsedPenLineWidth")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let controlPoints = aDecoder.decodeObject(forKey: "ControlPoints") as? [CGPoint] else {
            return nil
        }
        
        guard let forces = aDecoder.decodeObject(forKey: "Forces") as? [CGFloat] else {
            return nil
        }
        
        guard let touchingMode = aDecoder.decodeObject(forKey: "TouchingMode") as? [Bool] else {
            return nil
        }
        
        guard let usedColor = aDecoder.decodeObject(forKey: "UsedColor") as? RGB else {
            return nil
        }
        guard let usedPenLineWidth = aDecoder.decodeObject(forKey: "UsedPenLineWidth") as? CGFloat else {
            return nil
        }
        
        ControlPoints = controlPoints
        Forces = forces
        TouchingMode = touchingMode
        UsedColor = usedColor
        UsedPenLineWidth = usedPenLineWidth
    }
    
    
    var ControlPoints : [CGPoint]
    var Forces : [CGFloat]
    var TouchingMode : [Bool]
    var UsedColor : RGB
    var UsedPenLineWidth : CGFloat
    
    init(ControlPoints : [CGPoint], Forces : [CGFloat], TouchingMode : [Bool], UsedColor : RGB, UsedPenLineWidth : CGFloat) {
        self.ControlPoints = ControlPoints
        self.Forces = Forces
        self.TouchingMode = TouchingMode
        self.UsedColor = UsedColor
        self.UsedPenLineWidth = UsedPenLineWidth
    }
    
}

class ColorAnchor : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: "color")
        aCoder.encode(point, forKey: "point")
        aCoder.encode(path, forKey: "path")
        aCoder.encode(layer, forKey: "layer")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let _color = aDecoder.decodeObject(forKey: "color") as? RGB else {
            return nil
        }
        let _point = aDecoder.decodeCGPoint(forKey: "point")
        guard let _path = aDecoder.decodeObject(forKey: "path") as? UIBezierPath else {
            return nil
        }
        guard let _layer = aDecoder.decodeObject(forKey: "layer") as? CAShapeLayer else {
            return nil
        }
        
        color = _color
        point = _point
        path = _path
        layer = _layer
    }
    
    var color : RGB
    var point : CGPoint
    var path : UIBezierPath
    var layer : CAShapeLayer
    
    init(color : RGB, point : CGPoint, path : UIBezierPath, layer : CAShapeLayer) {
        self.color = color
        self.point = point
        self.path = path
        self.layer = layer
    }
}

class ColorHint : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: "color")
        aCoder.encode(point, forKey: "point")
        aCoder.encode(path, forKey: "path")
        aCoder.encode(layer, forKey: "layer")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let _color = aDecoder.decodeObject(forKey: "color") as? RGB else {
            return nil
        }
        let _point = aDecoder.decodeCGPoint(forKey: "point")
        guard let _path = aDecoder.decodeObject(forKey: "path") as? UIBezierPath else {
            return nil
        }
        guard let _layer = aDecoder.decodeObject(forKey: "layer") as? CAShapeLayer else {
            return nil
        }
        
        color = _color
        point = _point
        path = _path
        layer = _layer
    }
    
    var color : RGB
    var point : CGPoint
    var path : UIBezierPath
    var layer : CAShapeLayer
    
    init(color : RGB, point : CGPoint, path : UIBezierPath, layer : CAShapeLayer) {
        self.color = color
        self.point = point
        self.path = path
        self.layer = layer
    }
}


enum ColorPointType {
    case Anchor
    case Hint
}

enum UsingToolType {
    case Drawing
    case ColorAnchor
    case ColorHint
    case Eraser
    case Pinching
}
