//
//  ColorizeServices.swift
//  iAnime
//
//  Created by NemesissLin on 2019/12/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage

class ColorizeServices {
    
    static func SendColorizeRequest(_ RequestBodyJSON : JSON, _ HandleSuccess: ((String)->Void)?, _ HandleFailed : ((Int,Error?)->Void)?) {
        
        request(ApiCollection.ColorizeRequest, method: .post, parameters: RequestBodyJSON.dictionaryObject, encoding: JSONEncoding.default, headers: Auth.AuthHeader).validate().responseJSON(completionHandler: {
            resp in
            switch resp.result {
            case .success(let value):
                let json = JSON(value)
                if Successful(json) {
                    let receipt = json["Receipt"].stringValue
                    HandleSuccess?(receipt)
                }
                else {
                    HandleFailed?(json["StatusCode"].intValue,nil)
                }
            case .failure(let err):
                print(err)
                HandleFailed?(-3,err)
            }
        })
    }
    
    static func QueryColorizeRequestStatus(_ Receipt : String, _ HandleSuccess : ((JSON)->Void)?, _ HandleFailed : ((Int,Error?)->Void)?) {
        let param = ["receipt" : Receipt ]
        request(ApiCollection.ColorizeStatus, method: .get, parameters: param, encoding: URLEncoding.default, headers: Auth.AuthHeader).validate().responseJSON(completionHandler: {
            resp in
            switch resp.result {
            case .success(let value):
                let json = JSON(value)
                if json["StatusCode"] == -1 {
                    HandleFailed?(-1,nil)
                }
                else {
                    HandleSuccess?(json)
                }
            case .failure(let err):
                print(err)
                HandleFailed?(-2,err)
            }
        })
    }
    
    static func ReceiveColorizedImage(_ Receipt : String, _ HandleSuccess: ((Image)->Void)?, _ HandleFailed: ((Error?)->Void)?) {
        request(ApiCollection.ColorizeResult, method: .get, parameters: ["receipt":Receipt], encoding: URLEncoding.default, headers: Auth.AuthHeader).validate().responseImage(completionHandler: {
            resp in
            switch resp.result {
            case .success(let value):
                let img = value
                HandleSuccess?(img)
            case .failure(let err):
                print(err)
                HandleFailed?(err)
            }
        })
    }
}
