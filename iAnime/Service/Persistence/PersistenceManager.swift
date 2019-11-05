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
    
    private(set) var UrlsArray : [URL]?
    init(urls : [URL]) {
        Background = urls[0]
        Foreground = urls[1]
        Lines = urls[2]
        Anchors = urls[3]
        Hints = urls[4]
        UrlsArray = urls
    }
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
        
        let foreground = FileManager.default.fileExists(atPath: GetDraftFilesURLs().Foreground.absoluteString)
        let lines = FileManager.default.fileExists(atPath: GetDraftFilesURLs().Lines.absoluteString)
        
        return foreground && lines
    }
    
    
    
    public static func PersistDraftData() {
        
    }
    
    public static func LoadDraftData() {
        
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
        let subpaths = ["background","foreground","lines","anchors","hints"]
        let combinedUrls = subpaths.map { path -> URL in
            var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            url.appendPathComponent("draft")
            url.appendPathComponent(path)
            return url
        }
        return DraftFilesURLCollection(urls: combinedUrls)
    }
}
