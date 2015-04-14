//
//  GameLevel.swift
//  Planck
//
//  Created by Jiang Sheng on 5/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.

import UIKit
import Foundation

class GameLevel: NSObject, NSCoding {
    class func loadGameWithIndex(index:Int) -> GameLevel? {
        let totalGame = StorageManager.defaultManager.numOfLevel()
        if index < 0 || index >= totalGame {
            return nil
        }
        return StorageManager.defaultManager.loadAllLevel()[index]
    }
    
    private let defaultName = "Deadline"
    
    /// The grid contained in this level
    var grid: GOGrid
    
    /// The XNodes contained in this level
    var xNodes: [String: XNode]
    
    /// The name of this level
    var name: String
    
    /// The index of this level
    var index: Int
    
    /// The desire music for this level
    var targetMusic: XMusic = XMusic()
    
    /// The score user achieve on this level
    var bestScore:Int = 0
    
    /// Whether this level is unlocked
    var isUnlock:Bool = false
    
    init(levelName: String, levelIndex: Int, grid: GOGrid, nodes: [String: XNode], targetMusic: XMusic) {
        self.name = levelName
        self.index = levelIndex
        self.grid = grid
        self.xNodes = nodes
        self.targetMusic = targetMusic
    }
    
    init(levelName: String, levelIndex: Int, grid: GOGrid, nodes: [String: XNode]) {
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
        var levelName = aDecoder.decodeObjectForKey(NSCodingKey.GameName) as String
        var index = aDecoder.decodeObjectForKey(NSCodingKey.GameIndex) as Int
        var grid = aDecoder.decodeObjectForKey(NSCodingKey.GameGrid) as GOGrid
        var xNodes = aDecoder.decodeObjectForKey(NSCodingKey.GameNodes) as [String: XNode]
        var music = aDecoder.decodeObjectForKey(NSCodingKey.GameTargetMusic) as XMusic
        var bestScore = aDecoder.decodeObjectForKey(NSCodingKey.GameBestScore) as Int
        var isUnlock = aDecoder.decodeBoolForKey(NSCodingKey.GameUnlock)
        
        self.init(levelName:levelName, levelIndex: index, grid:grid, nodes:xNodes, targetMusic:music)
        self.bestScore = bestScore
        self.isUnlock = isUnlock
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: NSCodingKey.GameName)
        aCoder.encodeObject(self.index, forKey: NSCodingKey.GameIndex)
        aCoder.encodeObject(self.grid, forKey: NSCodingKey.GameGrid)
        aCoder.encodeObject(self.xNodes, forKey: NSCodingKey.GameNodes)
        aCoder.encodeObject(self.targetMusic, forKey: NSCodingKey.GameTargetMusic)
        aCoder.encodeObject(self.bestScore, forKey: NSCodingKey.GameBestScore)
        aCoder.encodeBool(self.isUnlock, forKey: NSCodingKey.GameUnlock)
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

