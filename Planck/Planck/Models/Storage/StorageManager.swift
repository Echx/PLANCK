//
//  StorageManager.swift
//  Planck
//
//  Created by Jiang Sheng on 22/3/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

private let SingletonSharedInstance = StorageManager()

class StorageManager:NSObject  {
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
    }
        
    // load the level based on the file name
    func loadLevel(filename:NSString) -> GameLevel {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        // the dat name should be set by user
        var filePath : NSString = documentsPath.stringByAppendingPathComponent(filename)
        println(filePath)
        let data = NSData(contentsOfFile: filePath)
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
        return unarchiver.decodeObjectForKey(keyForArchieve) as GameLevel
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
            if (filename.pathExtension) != nil {
                if (filename.pathExtension == StorageDefault.levelDataType) {
                    total++
                }
            }
        }
        return total
    }
    
    func loadAllLevels() -> [GameLevel] {
        // find out the document path
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(path,
            error: nil)! as NSArray
        
        var levelArray = [GameLevel]()
        
        // iterate each filename to add
        for filename in fileArray {
            if ((filename.pathExtension) != nil) {
                if (filename.pathExtension == levelDataFileType) {
                    let game = self.loadLevel(filename as NSString)
                    levelArray.append(game)
                }
            }
        }
        
        // sort the levelArray based on Index
        levelArray.sort{$0<$1}
        
        return levelArray
    }

}
