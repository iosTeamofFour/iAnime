//
//  Pair.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

struct Pair<TKey,TValue> {
    var key : TKey
    var value  : TValue
    init(_ key: TKey, _ value : TValue) {
        self.key = key
        self.value = value
    }
}
