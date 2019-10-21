//
//  ColorPicker.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/21.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

class ColorPickerHelper {
    
    public static func GenerateColorPickerBarRGBItems() -> [[Int]] {
        var BGR : [Int] = [0,0,255]
        
        var CurrentChange = 0
        var LastChange = 2
        var Down = false
        var LoopCount = 0
        
        var ColorItems : [[Int]] = []
        
        ColorItems.append(BGR.reversed())
        
        while LoopCount != 6 {
            
            if Down {
                while BGR[LastChange] != 0 {
                    BGR[LastChange] -= 1
                    ColorItems.append(BGR.reversed())
                }
                Down = false
                LastChange = CurrentChange
                CurrentChange += 1
            }
            else {
                while BGR[CurrentChange] != 255 {
                    BGR[CurrentChange] += 1
                    ColorItems.append(BGR.reversed())
                }
                Down = true
            }
            LoopCount += 1
        }
        return ColorItems
    }
    
    static func DifferentAt<T : Comparable>(_ left :[T],_ right: [T]) -> Int {
        let ended = min(left.count,right.count)
        for i in 0..<ended {
            if left[i] != right[i] {
                return i
            }
        }
        return -1
    }
    
    static func Interpolate(_ curr:Float, _ next:Float,_ slices:Int) -> [Float] {
        if slices == 0 {
            fatalError("Cannot use zero slices!")
        }
        let delta = next - curr
        let step = delta / Float(slices)
        var result : [Float] = [curr]
        for i in 1...slices {
            result.append(curr + step * Float(i))
        }
        return result
    }
    
    public static func GetInterpolatedItems(_ original: [[Float]],_ slices: Int) -> [[Float]] {
        var originalCopy = original
        for i in 0..<original.count-1 {
            let CurrentItem = original[i]
            let NextItem = original[i+1]
            let diffIndex = DifferentAt(CurrentItem, NextItem)
            if diffIndex != -1 {
                let CurrentElem = CurrentItem[diffIndex]
                let NextElem = NextItem[diffIndex]
                let interpolated = Interpolate(CurrentElem, NextElem, slices)
                let NewElems = interpolated.map { value -> [Float] in
                    var result = CurrentItem
                    result[diffIndex] = value
                    return result
                }
                originalCopy.insert(NewElems.flatMap{ it in it }, at: i)
            }
        }
        return originalCopy
    }
}
