//
//  DrawingInfo.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/10.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

class DrawingInfo: NSObject, NSCoding {
    
    var DrawingID : String
    var Name : String
    var Description : String
    var Tags : [String]
    var AllowSaveToLocal : Bool
    var AllowFork : Bool
    var CreatedTime : Int
    func encode(with aCoder: NSCoder) {
        aCoder.encode(DrawingID, forKey: "DrawingID")
        aCoder.encode(Name, forKey: "Name")
        aCoder.encode(Description, forKey: "Description")
        aCoder.encode(Tags, forKey: "Tags")
        aCoder.encode(AllowSaveToLocal, forKey: "AllowSaveToLocal")
        aCoder.encode(AllowFork, forKey: "AllowFork")
        aCoder.encode(CreatedTime, forKey: "CreatedTime")
    }
    
    init(DrawingID : String,Name : String, Description : String, Tags : [String], AllowSaveToLocal : Bool, AllowFork : Bool, CreatedTime : Int) {
        
        self.DrawingID = DrawingID
        self.Name = Name
        self.Description = Description
        self.Tags = Tags
        self.AllowSaveToLocal = AllowSaveToLocal
        self.AllowFork = AllowFork
        self.CreatedTime = CreatedTime
    }

    required init?(coder aDecoder: NSCoder) {
        guard let drawingID = aDecoder.decodeObject(forKey: "DrawingID") as? String else {
            return nil
        }
        
        guard let name = aDecoder.decodeObject(forKey: "Name") as? String else {
            return nil
        }
        
        guard let description = aDecoder.decodeObject(forKey: "Description") as? String else {
            return nil
        }
        
        guard let tags = aDecoder.decodeObject(forKey: "Tags") as? [String] else {
            return nil
        }
        
        DrawingID = drawingID
        Name = name
        Description = description
        Tags = tags
        AllowSaveToLocal = aDecoder.decodeBool(forKey: "AllowSaveToLocal")
        AllowFork = aDecoder.decodeBool(forKey: "AllowFork")
        CreatedTime = aDecoder.decodeInteger(forKey: "CreatedTime")
    }
}
