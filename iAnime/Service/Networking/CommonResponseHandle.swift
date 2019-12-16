//
//  CommonResponseHandle.swift
//  iAnime
//
//  Created by NemesissLin on 2019/12/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import SwiftyJSON

public func Successful(_ json : JSON) -> Bool {
    if let stat = json["StatusCode"].int, stat == 0 {
        return true
    }
    return false
}
