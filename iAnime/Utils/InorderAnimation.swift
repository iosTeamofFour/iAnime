//
//  InorderAnimation.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/7.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

struct ExecuteAnimation {
    var Duration : TimeInterval
    var Delay : TimeInterval
    var Options : UIView.AnimationOptions
    var WhenComplete : ((Bool) -> Void)?
    var DoAnimation : () -> Void
    
}

class InorderAnimation {
    private(set) var AnimationList : [ExecuteAnimation] = []
    init() {
        
    }
    init(_ animations : [ExecuteAnimation]) {
        AnimationList.append(contentsOf: animations)
    }

    private var Current = -1
    
    func AddAnimation(animation : ExecuteAnimation) {
        AnimationList.append(animation)
    }
    
    func RemoveAnimationAt(index : Int) {
        if(index >= AnimationList.count) {
            return
        }
        AnimationList.remove(at: index)
    }
    func RemoveAllAnimation() {
        AnimationList.removeAll()
    }
    
    func Begin() {
        Current = -1
        Next()
    }
    private func Next() {
        Current += 1
        if Current < AnimationList.count {
            let currAnimation = self.AnimationList[Current]
            UIView.animate(withDuration: currAnimation.Duration, delay: currAnimation.Delay, options: currAnimation.Options, animations: {
                currAnimation.DoAnimation()
            }, completion: { (result) in
                currAnimation.WhenComplete?(result)
                self.Next()
            })
        }
    }
}
