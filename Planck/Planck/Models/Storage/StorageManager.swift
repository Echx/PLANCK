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
    private let levelDataFileType = ".dat"
    
    // save as {index}.dat
    func saveCurrentLevel(level:GameLevel) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(level, forKey: keyForArchieve)

        archiver.finishEncoding()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        let levelName = level.name + levelDataFileType
        // the dat name should be set by user
        var filePath : NSString = documentsPath.stringByAppendingPathComponent(levelName)
        data.writeToFile(filePath, atomically: true)
        
        // reload the cache after saving the games
        setNeedsReload()
    }
        
    // load the level based on the file name
    func loadLevel(filename:NSString) -> GameLevel {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        // the dat name should be set by user
        var filePath : NSString = documentsPath.stringByAppendingPathComponent(filename)

        let data = NSData(contentsOfFile: filePath)
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
        return unarchiver.decodeObjectForKey(keyForArchieve) as GameLevel
    }
    
    func loadAllLevel() -> [GameLevel] {
        if isDirty {
            var levelArray = [GameLevel]()
            // find out the document path
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)[0] as NSString
            let fileManager = NSFileManager.defaultManager()
            let fileArray = fileManager.contentsOfDirectoryAtPath(path,
                error: nil)! as NSArray
            
            // iterate each filename to add
            for filename in fileArray {
                let name = filename as NSString
                // temp solution for dealing with file type
                if name.substringFromIndex(name.length - 4) == levelDataFileType {
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
        // find out the document path
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(path,
            error: nil)! as NSArray
        
        var total:Int = 0
        // iterate each filename to add
        for filename in fileArray {
            if filename.substringFromIndex(filename.length - 4) == levelDataFileType {
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
