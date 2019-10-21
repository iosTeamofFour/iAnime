//
//  ColorPicker.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/21.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

class ColorPickerHelper {
    
    public static func GenerateColorPickerBarRGBItems(_ step : Float) {
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
        
        
        print(ColorItems)
    }
}
