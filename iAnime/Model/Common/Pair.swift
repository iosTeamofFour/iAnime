//
//  Pair.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/20.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

class Pair<TKey,TValue> : NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")
        aCoder.encode(value, forKey: "value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let _key = aDecoder.decodeObject(forKey: "key") as? TKey else {
            return nil
        }
        guard let _value = aDecoder.decodeObject(forKey: "value") as? TValue else {
            return nil
        }
        
        key = _key
        value = _value
    }
    var key : TKey
    var value  : TValue
    init(_ key: TKey, _ value : TValue) {
        self.key = key
        self.value = value
    }
}
