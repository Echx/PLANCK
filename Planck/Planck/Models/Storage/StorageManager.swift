//
//  StorageManager.swift
//  Planck
//
//  Created by Jiang Sheng on 22/3/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// A singleton object
private let SingletonSharedInstance = StorageManager()

//This class manages consistant data storage
class StorageManager:NSObject {
    class var defaultManager : StorageManager {
        return SingletonSharedInstance
    }
    
    /// A boolean indicating if the storage manager needs to reload data
    private var isDirty:Bool = true
    
    /// cache the stored levels
    private var levelCache: [GameLevel] = [GameLevel]()
    private var userLevelCache: [GameLevel] = [GameLevel]()
    
    /// Initialize storage folder
    func initStorage() {
        /// create necessary folder if needed.
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(XFileConstant.libraryPath) {
            // init Application Support folder
            fileManager.createDirectoryAtPath(XFileConstant.libraryPath,
                withIntermediateDirectories: false, attributes: nil, error: nil)
            
            if !fileManager.fileExistsAtPath(XFileConstant.defaultLevelDir) {
                // init Application Support/com.echx.planck folder for saving levels
                fileManager.createDirectoryAtPath(XFileConstant.defaultLevelDir,
                    withIntermediateDirectories: false, attributes: nil, error: nil)
            }
        }
        if !fileManager.fileExistsAtPath(XFileConstant.userLevelDir) {
            fileManager.createDirectoryAtPath(XFileConstant.userLevelDir,
                withIntermediateDirectories: false, attributes: nil, error: nil)
        }
    }
    
    /// Initialize game levels by copying pre-defined game levels to the directory
    func copyGameLevels() {
        let preloadGames = NSBundle.mainBundle().pathsForResourcesOfType(SystemDefault.levelDataType, inDirectory: nil)
        let fileManager = NSFileManager.defaultManager()
        for levelPath in preloadGames {
            let levelPath = levelPath as NSString
            let levelName = levelPath.lastPathComponent
            let destPath = XFileConstant.defaultLevelDir.stringByAppendingPathComponent(levelName)
            fileManager.copyItemAtPath(levelPath, toPath: destPath, error: nil)
        }
    }
    
    /// Save a level to a file
    /// :param: level the game level to be saved
    func saveCurrentLevel(level:GameLevel) {
        // REQUIRES: level is not nil
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(level, forKey: NSCodingKey.Game)

        archiver.finishEncoding()
        
        let levelName = level.name + SystemDefault.levelDataFileExtension
        // save to system levels folder
        var filePath : NSString = XFileConstant.defaultLevelDir.stringByAppendingPathComponent(levelName)
        data.writeToFile(filePath, atomically: true)
        
        // reload the cache after saving the games
        setNeedsReload()
    }
        
    /// Load the level based on the file name and level type
    /// :param: filename the name of the file to be load
    /// :param: isSystemLevel a boolean indicating the location of the file
    /// :returns: a single game level loaded
    func loadLevel(filename:NSString, isSystemLevel: Bool) -> GameLevel {
        // REQUIRES: filename is valid (english chars only with non-zero length)
        
        var filePath: NSString = XFileConstant.defaultLevelDir.stringByAppendingPathComponent(filename)
        if !isSystemLevel {
            filePath = XFileConstant.userLevelDir.stringByAppendingPathComponent(filename)
        }

        let data = NSData(contentsOfFile: filePath)
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
        return unarchiver.decodeObjectForKey(NSCodingKey.Game) as GameLevel
    }
    
    /// Load all system levels
    /// :returns: an array of game levels
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
                if name.pathExtension == SystemDefault.levelDataType {
                    let game = loadLevel(name, isSystemLevel: true)
                    levelArray.append(game)
                }
            }
            
            // sort the levelArray based on Index
            levelArray.sort{$0<$1}
            
            // set up cache
            levelCache = levelArray
            
            return levelArray
        } else {
            // if the levels are not changed, just return the cache value
            return levelCache
        }
    }
    
    /// Load all user created levels
    /// :returns: an array of game levels
    func loadAllUserLevel() -> [GameLevel] {
        if isDirty {
            var levelArray = [GameLevel]()
            
            let fileManager = NSFileManager.defaultManager()
            let fileArray = fileManager.contentsOfDirectoryAtPath(XFileConstant.userLevelDir,
                error: nil)! as NSArray
            
            // iterate each filename to add
            for filename in fileArray {
                let name = filename as NSString
                // temp solution for dealing with file type
                if name.pathExtension == SystemDefault.levelDataType  {
                    let game = loadLevel(name, isSystemLevel: false)
                    levelArray.append(game)
                }
            }
            
            // set up cache
            userLevelCache = levelArray
            
            return levelArray
        } else {
            // if the levels are not changed, just return the cache value
            return userLevelCache
        }
    }
    
    /// Count number of system levels in total
    /// :returns: a total count
    func numOfLevel() -> Int {
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(XFileConstant.defaultLevelDir,
            error: nil)! as NSArray
        
        var total:Int = 0
        // iterate each filename to add
        for filename in fileArray {
            if filename.pathExtension == SystemDefault.levelDataType  {
                total++
            }
        }
        return total
    }
    
    /// Count number of user created levels in total
    /// :returns: a total count
    func numOfUserLevel() -> Int {
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(XFileConstant.userLevelDir,
            error: nil)! as NSArray
        
        var total:Int = 0
        // iterate each filename to add
        for filename in fileArray {
            if filename.pathExtension == SystemDefault.levelDataType  {
                total++
            }
        }
        return total
    }
    
    /// Reload the levels
    /// :returns: a total count
    func setNeedsReload() {
        // reload cache
        isDirty = true
        self.loadAllLevel()
        self.loadAllUserLevel()
        isDirty = false
    }
}
