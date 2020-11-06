//
//  FileHelper.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 26.02.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation

open class FileHelper {
    
    public static let shared: FileHelper = {
        
        let instance = FileHelper()
        
        return instance
    }()
    
    public var securityApplicationGroupIdentifier: String = ""
    
    public func getAllFiles(_ path: String) -> [String] {
        var results = [String]()
        do {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
                let contents = try FileManager.default.contentsOfDirectory(atPath: path)
                
                for item in contents {
                    let filePath = String(format: "%@/%@", path, item)
                    results.append(filePath)
                }
            }
        } catch let error as NSError {
            log("getDownloaded fromPath ERROR: ", error.localizedDescription)
        }
        return results
    }
    public func urlIsMediaFile(_ url: URL) -> Bool {
        let fileextensions = ["aac", "ac3", "aif",
                              "aiff", "aifc", "caf",
                              "mp3", "mp4", "m4a", "m4b", "m4v", "mov", "wav"]
        return fileextensions.contains(url.pathExtension.lowercased())
    }
    public func urlIsVideoFile(_ url: URL) -> Bool {
        let fileextensions = ["mp4", "m4v", "mov"]
        return fileextensions.contains(url.pathExtension.lowercased())
    }
    public func urlIsOPMLFile(_ url: URL) -> Bool {
        let fileextensions = ["opml", "xml"]
        return fileextensions.contains(url.pathExtension.lowercased())
    }
    
    public func getDownloadedImages() -> [String] {
        let path = self.getImagesFolderPath()
        return self.getAllFiles(path)
    }
    
    
    public func getBaseDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as String
        
        return documentsDirectory
    }
    public func getUrlSessionDownloadFolderPath() -> String {
        let documentsDirectory = self.getBaseDirectory()
        
        let path = documentsDirectory.appending("/urlSessionDownloadFolder")
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch _ as NSError {
            
        }
        return path
    }
    public func getUrlSessionResumeDataFolderPath() -> String {
        let documentsDirectory = self.getBaseDirectory()
        
        let path = documentsDirectory.appending("/urlSessionResumeDataFolder")
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch _ as NSError {
            
        }
        return path
    }
    #if os(tvOS)
    public func getDatabaseFolderPath() -> String {
        let documentsDirectory = FileHelper.getBaseDirectory()
        
        return documentsDirectory
    }
    #endif
    
    public func getImagesFolderPath() -> String {
        var documentsDirectory = self.getBaseDirectory()
        
        #if os(iOS)
        if let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.securityApplicationGroupIdentifier) {
            let path = documentsDirectory.appending("/images")
            for item in FileHelper.shared.getAllFiles(path) {
                do {
                    try FileManager.default.removeItem(atPath: item)
                } catch _ as NSError {
                    
                }
            }
            
            documentsDirectory = containerPath.path
        }
        #endif
        
        let path = documentsDirectory.appending("/images")
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch _ as NSError {
            
        }
        return path
    }
    
    public func getStatisticExportFolderPath() -> String {
        let documentsDirectory = self.getBaseDirectory()
        
        let path = documentsDirectory.appending("/statistic_export")
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            log("Error: \(error)")
        }
        return path
    }
    public func getStatisticExportArchiveFolderPath() -> String {
        let documentsDirectory = self.getBaseDirectory()
        
        let path = documentsDirectory.appending("/statistic_export_archive")
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            log("Error: \(error)")
        }
        return path
    }
    public func getFileSizeFromFile(_ path: String) -> Float {
        var usedDiscspace: Float = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            if let fileSize = attr[FileAttributeKey.size] as? Double {
                
                usedDiscspace += Float(fileSize)
            } else if let fileSize = attr[FileAttributeKey.size] as? Int {
                
                usedDiscspace += Float(fileSize)
            } else if let fileSize = attr[FileAttributeKey.size] as? Float {
                
                usedDiscspace += fileSize
            }
        } catch {
            log("Error: \(error)")
            
        }
        return usedDiscspace
    }
}


