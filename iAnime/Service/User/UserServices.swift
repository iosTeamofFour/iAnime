//
//  UserServices.swift
//  iAnime
//
//  Created by NemesissLin on 2019/12/14.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserServices {
    
    public func Login(Phone : String, Password : String, ShouldEncryptPassword : Bool = true, HandleSuccess : ((Int) -> Void)?, HandleFailed : (() -> Void)?) {
        
        let phone = Phone.trimmingCharacters(in: [" "])
        let encrypted = ShouldEncryptPassword ? HMACSHA256.Hash(Message: Password) : Password
        let param = ["phone" : phone, "password" : encrypted ]
        
        request(ApiCollection.Login, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { resp in
                switch resp.result {
                case .success(let value):
                    let json = JSON(value)
                    let StatusCode = json["StatusCode"].intValue
                    if StatusCode == 0 {
                        self.RememberJWTToken(json["Token"].stringValue)
                    }
                    HandleSuccess?(StatusCode)
                case .failure(let err):
                    print(err)
                    HandleFailed?()
                }
            })
    }
    
    public func Register(Phone : String, Password : String) {
        let phone = Phone.trimmingCharacters(in: [" "])
        let encrypted = HMACSHA256.Hash(Message: Password)
        let param = ["phone" : phone, "password" : encrypted ]
    }
    
    public func RememberLoginStatus(Phone : String, EncryptedPassword : String) {
        UserDefaults.standard.set(EncryptedPassword, forKey: "Password")
        UserDefaults.standard.set(Phone, forKey: "Phone")
    }
    public func RememberJWTToken(_ token : String) {
        print("Will Remember such token: \(token)")
        UserDefaults.standard.set(token, forKey: "Token")
    }
    
    public var JwtToken : String {
        get {
            return (UserDefaults.standard.object(forKey: "Token") as? String) ?? ""
        }
    }
}
