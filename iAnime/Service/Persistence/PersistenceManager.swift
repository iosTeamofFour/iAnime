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

enum FileType : String {
    case DrawingHistory = "draftData"
    case DrawingInfo = "drawingInfo"
}

class PersistenceManager {
    // 考虑将草稿保存到 用户的 ./draft/文件夹下
    // 背景: ./draft/background
    // 前景: ./draft/foreground
    // 笔迹数据 ./draft/lines
    // 颜色锚点数据 ./draft/anchors
    // 颜色标记点数据 ./draft/hints
    
    static var DraftFilesURLs : DraftFilesURLCollection!
    
//
//    public static func CheckIfDraftExists() -> Bool {
//        return FileManager.default.fileExists(atPath: GetDraftFilesURLs().AllDataBlocks.path)
//    }
//
    
    
//    public static func PersistDraftData(_ data : DraftData) -> Bool {
//        return NSKeyedArchiver.archiveRootObject(data, toFile: GetDraftFilesURLs().AllDataBlocks.path)
//    }
    
    public static func GetFolderURL(_ folderType : FolderType, _ id : String? = nil) -> URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent(folderType.rawValue)
        if let _id = id {
            url.appendPathComponent(_id)
        }
        return url
    }
    
    public static func GetFileURL(_ folderType : FolderType, _ fileType : FileType, _ id : String) -> URL {
        var folder = GetFolderURL(folderType, id)
        folder.appendPathComponent(fileType.rawValue)
        return folder
    }
    
    public static func PersistLocalWorkDataWithDrawingInfo(_ data : DraftData?, _ info : DrawingInfo) -> Bool {
        // 检测对应的文件夹是否存在
        
        var folder = GetFolderURL(.LocalWork, info.DrawingID)
        if !IfFolderExists(folder) && !TryCreateFolder(folder) {
            // 文件夹不存在且不能创建对应的文件夹，返回持久化失败。
            return false
        }
        
        if let draftData = data {
            folder.appendPathComponent(FileType.DrawingHistory.rawValue)
            
            let PersistDraftResult = NSKeyedArchiver.archiveRootObject(draftData, toFile: folder.path)
            
            if !PersistDraftResult {
                return false
            }
            folder.deleteLastPathComponent()
        }
        
        folder.appendPathComponent(FileType.DrawingInfo.rawValue)
        // PersistDrawingInfoResult
        return NSKeyedArchiver.archiveRootObject(info, toFile: folder.path)
    }
    
    public static func LoadLocalWorkDataWithDrawingInfo(_ id : String) -> (DrawingInfo?, DraftData?) {
        let infoURL = GetFileURL(.LocalWork, .DrawingInfo, id)
        let dataURL = GetFileURL(.LocalWork, .DrawingHistory, id)
        if !IfFileExists(infoURL) {
            return (nil,nil)
        }
        let drawingInfo = LoadObject(infoURL) as? DrawingInfo
        let draftData = LoadObject(dataURL) as? DraftData
        
        return (drawingInfo, draftData)
        
    }
    
    public static func LoadLocalWorkDrawingInfo(_ id : String) -> DrawingInfo? {
        let url = GetFileURL(.LocalWork, .DrawingInfo, id)
        return LoadObject(url) as? DrawingInfo
    }
    
    public static func LoadObject(_ url : URL) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: url.path)
    }
    
    public static func ListAllLocalWork() -> [String] {
        let folder = GetFolderURL(.LocalWork, nil)
        do {
            return try FileManager.default.contentsOfDirectory(atPath: folder.path)
        }
        catch {
            print("Error - 无法加载全部的本地数据")
            return []
        }
    }
    
    public static func LoadAllLocalWorkDrawingInfo(_ works : [String]) -> [DrawingInfo?] {
        return works
            .map { work in LoadLocalWorkDrawingInfo(work) }
            .filter { info in info != nil }
    }
    
    public static func IfFolderExists(_ directoryURL : URL) -> Bool {
        var isDirectory = ObjCBool(true)
        return FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory)
    }
    
    public static func IfFileExists(_ fileURL : URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.path)
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
    
//    public static func LoadDraftData(_ folderType : FolderType, _ id : String) -> DraftData? {
////        do {
////            let data = try Data(contentsOf: GetDraftFilesURLs().AllDataBlocks)
////            if let draftData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DraftData {
////                return draftData
////            }
////        }
////        catch {
////            print("从文件加载失败.")
////        }
////        return nil
//
//        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: GetDraftFilesURLs().AllDataBlocks.path) as? DraftData {
//            return data
//        }
//        return nil
//    }
    
    public static func DeteleDraftData() {
        GetDraftFilesURLs().UrlsArray?.forEach { url in
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    public static func DeleteRecord(_ folderType : FolderType, _ id : String) -> Bool {
        let folder = GetFolderURL(folderType, id)
        
        do {
            try FileManager.default.removeItem(at: folder)
            return true
        }
        catch {
            print("删除记录失败 \(folder.path)")
            return false
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
