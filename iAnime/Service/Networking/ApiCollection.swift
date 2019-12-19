//
//  ApiCollection.swift
//  iAnime
//
//  Created by NemesissLin on 2019/12/14.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

public class ApiCollection {
    
    // User
    public static let Prefix = "http://192.168.88.126:3000"
    public static let Login = Prefix + "/user/login"
    public static let Register = Prefix + "/user/register"
    public static let Profile = Prefix + "/user/profile"
    public static let Avatar = Prefix + "/user/avatar"
    public static let BackgroundPhoto = Prefix + "/user/background"
    public static let Follower = Prefix + "/user/follower"
    public static let Following = Prefix + "/user/following"
    public static let FollowOperation = Prefix + "/user/follow"
    
    // Illustration
    public static let ColorizeRequest = Prefix + "/illustration/colorization"
    public static let ColorizeStatus = Prefix + "/illustration/colorization/status"
    public static let ColorizeResult = Prefix + "/illustration/colorization/result"
    
    
    public static let PublishWork = Prefix + "/illustration/upload"
    public static let UserWork = Prefix + "/illustration/mywork"
    public static let WorkImage = Prefix + "/illustration/image"
}
