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
    
    // MARK: - Save & Load
    func saveCurrentLevel() {
        
    }
    
    // load the level based on the file name
    func loadLevel(filename:NSString) {
        
    }
    
}
