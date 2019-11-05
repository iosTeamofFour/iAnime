//
//  PersistenceManager.swift
//  iAnime
//
//  Created by NemesissLin on 2019/11/5.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import Foundation

struct DraftFilesURLCollection {
    var Background : URL
    var Foreground : URL
    var Lines : URL
    var Anchors : URL
    var Hints : URL
    var AllDataBlocks : URL
    private(set) var UrlsArray : [URL]?
    init(urls : [URL]) {
        Background = urls[0]
        Foreground = urls[1]
        Lines = urls[2]
        Anchors = urls[3]
        Hints = urls[4]
        AllDataBlocks = urls[5]
        UrlsArray = urls
    }
}

enum PersistenceException : Error {
    case NotSerializationException
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
    
    
    
    public static func PersistDraftData(_ data : DraftData) -> Bool {
        return NSKeyedArchiver.archiveRootObject(data, toFile: GetDraftFilesURLs().AllDataBlocks.path)
    }
    
    public static func LoadDraftData() -> DraftData? {
        do {
            let data = try Data(contentsOf: GetDraftFilesURLs().AllDataBlocks)
            if let draftData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DraftData {
                return draftData
            }
        }
        catch {
            print("从文件加载失败.")
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
        let subpaths = ["background","foreground","lines","anchors","hints","data"]
        let combinedUrls = subpaths.map { path -> URL in
            var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            url.appendPathComponent(path)
            return url
        }
        return DraftFilesURLCollection(urls: combinedUrls)
    }
}
