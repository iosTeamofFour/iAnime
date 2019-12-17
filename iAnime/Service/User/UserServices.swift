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
import AlamofireImage

class UserServices {
    
    var CurrentUserProfile : UserProfile?
    
    public func Login(Phone : String, Password : String, ShouldEncryptPassword : Bool = true, HandleSuccess : ((Int) -> Void)?, HandleFailed : ((Int) -> Void)?) {
        
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
                        self.RememberLoginUserAccount(Phone: phone, EncryptedPassword: encrypted)
                        HandleSuccess?(StatusCode)
                    }
                    else {
                        HandleFailed?(StatusCode)
                    }
                case .failure(let err):
                    print(err)
                    HandleFailed?(-2)
                }
            })
    }
    

    
    public func Register(Phone : String, Password : String,  HandleSuccess : ((Int) -> Void)?, HandleFailed : (() -> Void)?) {
        let phone = Phone.trimmingCharacters(in: [" "])
        let encrypted = HMACSHA256.Hash(Message: Password)
        let param = ["phone" : phone, "password" : encrypted ]
        
        
        request(ApiCollection.Register, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON(completionHandler: { resp in
                switch resp.result {
                case .success(let value):
                    let json = JSON(value)
                    let StatusCode = json["StatusCode"].intValue
                    HandleSuccess?(StatusCode)
                case .failure(let err):
                    print(err)
                    HandleFailed?()
                }
            })
    }
    
    public func LoadSelfProfile(_ HandleLoaded : ((JSON)->Void)?, _ HandleFailed : ((Error)->Void)?) {
        let MyUserID = Auth.GetUserIDFromToken()
        
        LoadUserProfile(UserID: MyUserID, {
            json in
            if json["StatusCode"].intValue == 0 {
                let profile = json["Profile"]
                let NickName = profile["NickName"].stringValue
                let Signature = profile["Signature"].stringValue
                let rank = profile["Rank"].intValue
                self.CurrentUserProfile = UserProfile.init(UserId: MyUserID, Rank: rank, NickName: NickName, Signature: Signature)
                HandleLoaded?(json)
            }
        }, HandleFailed)
    }
    
    
    public func LoadUserProfile(UserID : Int, _ HandleLoaded : ((JSON)->Void)?, _ HandleFailed : ((Error)->Void)?) {
        
        let param = ["userid": UserID]
        
        request(ApiCollection.Profile, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: Auth.AuthHeader).validate().responseJSON(completionHandler: {
            resp in
            switch resp.result {
            case .success(let value):
                let json = JSON(value)
                HandleLoaded?(json)
            case .failure(let err):
                HandleFailed?(err)
            }
        })
    }
    
    public func FetchUserWork(UserID : Int, _ HandleLoaded : ((JSON)->Void)?, _ HandleFailed : ((Error)->Void)?) {
        let param = ["userid" : UserID, "type" : "detail"] as [String : Any]
        request(ApiCollection.UserWork, method: .get, parameters: param, encoding: URLEncoding.default, headers: Auth.AuthHeader)
        .validate()
            .responseJSON(completionHandler: {
                resp in
                switch resp.result {
                case .success(let value):
                    HandleLoaded?(JSON(value))
                case .failure(let err):
                    HandleFailed?(err)
                }
            })
    }
    public func FetchWorkImage(WorkID : Int, _ HandleLoaded : ((Image)->Void)?, _ HandleFailed : ((Error)->Void)?) {
        let param = ["id" : WorkID, "type" : "colorization"] as [String : Any]
        request(ApiCollection.WorkImage, method: .get, parameters: param, encoding: URLEncoding.default, headers: Auth.AuthHeader)
            .validate()
            .responseImage(completionHandler: {
                resp in
                switch resp.result {
                case .success(let value):
                    HandleLoaded?(value)
                case .failure(let err):
                    HandleFailed?(err)
                }
            })
    }
    
    public func TryAutoLogin(_ HandleAutoLogin : @escaping ((Bool)->Void)) {
        let (phone, passwd) = GetLoginUserAccount()
        if let UnwrapPhone = phone, let UnwrapPassword = passwd {
            Login(Phone: UnwrapPhone, Password: UnwrapPassword, ShouldEncryptPassword: false, HandleSuccess: {
                code in
                HandleAutoLogin(code == 0)
            }, HandleFailed: { _ in HandleAutoLogin(false) })
        }
        else {
            HandleAutoLogin(false)
        }
    }
    
    
    public func GetLoginUserAccount() -> (String?, String?) {
        let phone = UserDefaults.standard.object(forKey: "Phone") as? String
        let encryptedPasswd = UserDefaults.standard.object(forKey: "Password") as? String
        
        return (phone, encryptedPasswd)
    }
    
    public func RememberLoginUserAccount(Phone : String, EncryptedPassword : String) {
        UserDefaults.standard.set(EncryptedPassword, forKey: "Password")
        UserDefaults.standard.set(Phone, forKey: "Phone")
    }
    public func RememberJWTToken(_ token : String) {
        print("Will Remember such token: \(token)")
        UserDefaults.standard.set(token, forKey: "Token")
    }
}
