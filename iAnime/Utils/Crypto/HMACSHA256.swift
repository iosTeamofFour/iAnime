//
//  HMACSHA256.swift
//  iAnime
//
//  Created by NemesissLin on 2019/12/14.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import CryptoSwift


public class HMACSHA256 {
    private static let Secret = "iAnimeBackendSecret"
    public static func Hash(Message: String) -> String {
        let result = try! HMAC(key: Secret, variant: .sha256).authenticate(Message.bytes)
        
        let encoded = Data(bytes: result).base64EncodedString()
        return encoded
    }
}
