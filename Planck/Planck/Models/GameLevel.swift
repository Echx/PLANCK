//
//  GameLevel.swift
//  Planck
//
//  Created by Jiang Sheng on 5/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.

import UIKit
import Foundation

class GameLevel: NSObject, NSCoding {
    /// The grid contained in this level
    var grid:GOGrid
    
    /// The name of this level
    var name:String
    
    /// The index of this level
    var index:Int
    
    init(levelName:String, levelIndex: Int, grid:GOGrid) {
        self.name = levelName
        self.index = levelIndex
        self.grid = grid
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let levelName = aDecoder.decodeObjectForKey("name") as String
        let index = aDecoder.decodeObjectForKey("index") as Int
        let grid = aDecoder.decodeObjectForKey("grid") as GOGrid
        self.init(levelName:levelName, levelIndex: index, grid:grid)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.index, forKey: "index")
        aCoder.encodeObject(self.grid, forKey: "grid")
    }
}
