//
//  GameLevel.swift
//  Planck
//
//  Created by Jiang Sheng on 5/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.

import UIKit
import Foundation

class GameLevel: NSObject, NSCoding {
    private let defaultName = "Deadline"
    
    /// The grid contained in this level
    var grid:GOGrid
    
    /// The XNodes contained in this level
    var xNodes:[String: XNode]
    
    /// The name of this level
    var name:String
    
    /// The index of this level
    var index:Int
    
    /// THe desire music for this level
    var targetMusic:XMusic = XMusic()
    
    init(levelName:String, levelIndex: Int, grid:GOGrid, nodes: [String: XNode], targetMusic:XMusic) {
        self.name = levelName
        self.index = levelIndex
        self.grid = grid
        self.xNodes = nodes
        self.targetMusic = targetMusic
    }
    
    init(levelName:String, levelIndex: Int, grid:GOGrid, nodes: [String: XNode]) {
        self.name = levelName
        self.index = levelIndex
        self.grid = grid
        self.xNodes = nodes
    }
    
    init(levelIndex: Int, grid:GOGrid, nodes: [String: XNode]) {
        self.name = defaultName
        self.index = levelIndex
        self.grid = grid
        self.xNodes = nodes
    }
    
    override init() {
        self.name = ""
        self.index = 0
        self.grid = GOGrid(width: 0, height: 0, andUnitLength: 0)
        self.xNodes = [String: XNode]()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var levelName = aDecoder.decodeObjectForKey("name") as String
        var index = aDecoder.decodeObjectForKey("index") as Int
        var grid = aDecoder.decodeObjectForKey("grid") as GOGrid
        var xNodes = aDecoder.decodeObjectForKey("xnode") as [String: XNode]
        var music = aDecoder.decodeObjectForKey("music") as XMusic
        self.init(levelName:levelName, levelIndex: index, grid:grid, nodes:xNodes, targetMusic:music)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.index, forKey: "index")
        aCoder.encodeObject(self.grid, forKey: "grid")
        aCoder.encodeObject(self.xNodes, forKey: "xnode")
        aCoder.encodeObject(self.targetMusic, forKey: "music")
    }

}

extension GameLevel:Comparable, Equatable {
    
}

func ==(lhs: GameLevel, rhs: GameLevel) -> Bool {
    return lhs.name == rhs.name && lhs.index == rhs.index
}

func <(lhs: GameLevel, rhs: GameLevel) -> Bool {
    return lhs.index < rhs.index
}

