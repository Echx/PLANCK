//
//  StorageManager.swift
//  Planck
//
//  Created by Jiang Sheng on 22/3/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

private let SingletonSharedInstance = StorageManager()
private var isDirty:Bool = true

/// cache the levels
private var levelCache: [GameLevel] = [GameLevel]()

class StorageManager:NSObject {
    class var defaultManager : StorageManager {
        return SingletonSharedInstance
    }
    
    private let keyForArchieve = "GAMELEVEL"
    private let levelDataFileType = "dat"
    private let levelDataFileExtension = ".dat"
    
    func initStorage() {
        /// create necessary folder if needed.
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(XFileConstant.defaultLevelDir) {
            fileManager.createDirectoryAtPath(XFileConstant.defaultLevelDir,
                withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        if !fileManager.fileExistsAtPath(XFileConstant.userLevelDir) {
            fileManager.createDirectoryAtPath(XFileConstant.userLevelDir,
                withIntermediateDirectories: false, attributes: nil, error: nil)
        }
    }
    
    // save as {index}.dat
    func saveCurrentLevel(level:GameLevel) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(level, forKey: keyForArchieve)

        archiver.finishEncoding()
        
        let levelName = level.name + levelDataFileExtension
        // save to system levels folder
        var filePath : NSString = XFileConstant.defaultLevelDir.stringByAppendingPathComponent(levelName)
        data.writeToFile(filePath, atomically: true)
        
        // reload the cache after saving the games
        setNeedsReload()
    }
        
    // load the level based on the file name
    func loadLevel(filename:NSString) -> GameLevel {
        var filePath : NSString = XFileConstant.defaultLevelDir.stringByAppendingPathComponent(filename)

        let data = NSData(contentsOfFile: filePath)
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
        return unarchiver.decodeObjectForKey(keyForArchieve) as GameLevel
    }
    
    func loadAllLevel() -> [GameLevel] {
        if isDirty {
            var levelArray = [GameLevel]()

            let fileManager = NSFileManager.defaultManager()
            let fileArray = fileManager.contentsOfDirectoryAtPath(XFileConstant.defaultLevelDir,
                error: nil)! as NSArray
            
            // iterate each filename to add
            for filename in fileArray {
                let name = filename as NSString
                // temp solution for dealing with file type
                if name.pathExtension == levelDataFileType {
                    let game = loadLevel(name)
                    levelArray.append(game)
                }
            }
            
            // sort the levelArray based on Index
            levelArray.sort{$0<$1}
            
            // set up cache
            levelCache = levelArray
            
            // update isDirty
            isDirty = false
            return levelArray
        } else {
            // if the levels are not changed, just return the cache value
            return levelCache
        }
        
    }
    
    func numOfLevel() -> Int {
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(XFileConstant.defaultLevelDir,
            error: nil)! as NSArray
        
        var total:Int = 0
        // iterate each filename to add
        for filename in fileArray {
            if filename.pathExtension == levelDataFileType {
                total++
            }
        }
        return total
    }
    
    func setNeedsReload() {
        // reload cache
        isDirty = true
        self.loadAllLevel()
    }
}
