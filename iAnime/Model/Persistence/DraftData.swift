//
//  DraftData.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import UIKit

class DraftData : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Background, forKey: "Background")
        aCoder.encode(Foreground, forKey: "Foreground")
        aCoder.encode(Lines, forKey: "Lines")
        aCoder.encode(Anchors, forKey: "Anchors")
        aCoder.encode(Hints, forKey: "Hints")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let background = aDecoder.decodeObject(forKey: "Background") as? UIImage? else {
            return nil
        }
        guard let foreground = aDecoder.decodeObject(forKey: "Foreground") as? UIImage else {
            return nil
        }
        guard let lines = aDecoder.decodeObject(forKey: "Lines") as? [DrawingHistory] else {
            return nil
        }
        guard let anchors = aDecoder.decodeObject(forKey: "Anchors") as? Dictionary<Vector2,ColorAnchor>? else {
            return nil
        }
        guard let hints = aDecoder.decodeObject(forKey: "Hints") as? Dictionary<Vector2,ColorHint>? else {
            return nil
        }
        
        Background = background
        Foreground = foreground
        Lines = lines
        Anchors = anchors
        Hints = hints
    }
    
    
    var Background : UIImage?
    var Foreground : UIImage
    var Lines : [DrawingHistory]
    var Anchors : Dictionary<Vector2,ColorAnchor>?
    var Hints : Dictionary<Vector2,ColorHint>?
    
    init(background : UIImage?, foreground : UIImage, lines : [DrawingHistory], anchors : Dictionary<Vector2, ColorAnchor>?, hints : Dictionary<Vector2,ColorHint>?) {
        
        Foreground = foreground
        Lines = lines
        Background = background
        Anchors = anchors
        Hints = hints
    }
}
