//
//  PersistenceManager.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

struct DraftFilesURLCollection {
    var DraftFolderURL: URL
    var LocalWorkURL : URL
    
    private(set) var UrlsArray : [URL]?
    
    init(urls : [URL]) {
        DraftFolderURL = urls[0]
        LocalWorkURL = urls[1]
        UrlsArray = urls
    }
}

enum PersistenceException : Error {
    case NotSerializationException
}

enum FolderType : String {
    case Draft = "draft"
    case LocalWork = "local"
}

class PersistenceManager {
    // 考虑将草稿保存到 用户的 ./draft/文件夹下
    // 背景: ./draft/background
    // 前景: ./draft/foreground
    // 笔迹数据 ./draft/lines
    // 颜色锚点数据 ./draft/anchors
    // 颜色标记点数据 ./draft/hints
    
    static var DraftFilesURLs : DraftFilesURLCollection!
    
    
    public static func CheckIfDraftExists() -> Bool {
        return FileManager.default.fileExists(atPath: GetDraftFilesURLs().AllDataBlocks.path)
    }
    
    
    
//    public static func PersistDraftData(_ data : DraftData) -> Bool {
//        return NSKeyedArchiver.archiveRootObject(data, toFile: GetDraftFilesURLs().AllDataBlocks.path)
//    }
//
    
    public static func GetFolderURL(_ folderType : FolderType, _ id : String) -> URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent(folderType.rawValue)
        url.appendPathComponent(id)
        return url
    }
    
    public static func PersistDraftDataWithDrawingInfo(_ data : DraftData?, _ info : DrawingInfo) -> Bool {
        // 检测对应的文件夹是否存在
        
        var folder = GetFolderURL(.Draft, info.DrawingID)
        if !IfFolderExists(folder) && !TryCreateFolder(folder) {
            // 文件夹不存在且不能创建对应的文件夹，返回持久化失败。
            return false
        }
        
        if let draftData = data {
            folder.appendPathComponent("draftData")
            
            let PersistDraftResult = NSKeyedArchiver.archiveRootObject(draftData, toFile: folder.path)
            
            if !PersistDraftResult {
                return false
            }
            folder.deleteLastPathComponent()
        }
        
        folder.appendPathComponent("drawingInfo")
        return NSKeyedArchiver.archiveRootObject(info, toFile: folder.path)
    }
    
    public static func IfFolderExists(_ directoryURL : URL) -> Bool {
        var isDirectory = ObjCBool(true)
        return FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory)
    }
    
    public static func TryCreateFolder(_ folderURL : URL) -> Bool {
        
        //        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //        url.appendPathComponent(folderType.rawValue)
        
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            print("创建\(folderURL)目录成功")
            return true
        }
        catch {
            print("创建\(folderURL)目录失败")
            return false
        }
    }
    
    public static func LoadDraftData(_ folderType : FolderType, _ id : String) -> DraftData? {
//        do {
//            let data = try Data(contentsOf: GetDraftFilesURLs().AllDataBlocks)
//            if let draftData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DraftData {
//                return draftData
//            }
//        }
//        catch {
//            print("从文件加载失败.")
//        }
//        return nil
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: GetDraftFilesURLs().AllDataBlocks.path) as? DraftData {
            return data
        }
        return nil
    }
    
    public static func DeteleDraftData() {
        GetDraftFilesURLs().UrlsArray?.forEach { url in
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    
    static func GetDraftFilesURLs() -> DraftFilesURLCollection {
        if DraftFilesURLs == nil {
            DraftFilesURLs = ConstructDraftFilesUrls()
        }
        return DraftFilesURLs
    }
    
    static func ConstructDraftFilesUrls() -> DraftFilesURLCollection {
        let subpaths = [FolderType.Draft.rawValue, FolderType.LocalWork.rawValue]
        let combinedUrls = subpaths.map { path -> URL in
            var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            url.appendPathComponent(path)
            return url
        }
        return DraftFilesURLCollection(urls: combinedUrls)
    }
}
