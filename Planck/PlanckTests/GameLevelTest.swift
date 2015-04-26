//
//  GameLevelTest.swift
//  Planck
//
//  Created by Jiang Sheng on 25/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class GameLevelTest: XCTestCase {
    func testComparableAndEquatable() {
        // create test stub
        let grid = GOGrid(width: 50, height: 50, andUnitLength: 1)
        let nodes = [String: XNode]()
        let music = XMusic()
        
        // things to be tested
        let game1 = GameLevel(levelName: "game1", levelIndex: 1, grid: grid,
            solvedGrid: grid, nodes: nodes, targetMusic: music)
        let game2 = GameLevel(levelName: "game1", levelIndex: 1, grid: grid,
            solvedGrid: grid, nodes: nodes, targetMusic: music)
        let game3 = GameLevel(levelName: "game1", levelIndex: 10, grid: grid,
            solvedGrid: grid, nodes: nodes, targetMusic: music)
        
        XCTAssertEqual(game1 == game2, true, "Equatable not implemented correctly")
        XCTAssertEqual(game1 < game2, false, "Comparable not implemented correctly")
        XCTAssertEqual(game1 < game3, true, "Comparable not implemented correctly")
    }
    
    func testGetNextLevel() {
        // create test stub
        let grid = GOGrid(width: 50, height: 50, andUnitLength: 1)
        let nodes = [String: XNode]()
        let music = XMusic()
        
        // things to be tested
        let game = GameLevel(levelName: "game1", levelIndex: 50, grid: grid,
            solvedGrid: grid, nodes: nodes, targetMusic: music)
        
        XCTAssertEqual(game.indexForNextLevel, 51,
            "Get next level not implemented correctly")
    }
    
    func testDeepcopy() {
        // create test stub
        let grid = GOGrid(width: 50, height: 50, andUnitLength: 1)
        let nodes = [String: XNode]()
        let music = XMusic()
        
        // things to be tested
        let game = GameLevel(levelName: "game1", levelIndex: 50, grid: grid,
            solvedGrid: grid, nodes: nodes, targetMusic: music)
        
        let copy = game.deepCopy()
        
        // if we change copy, original game should not change
        copy.index = 20
        
        XCTAssertEqual(copy.index, 20, "Deep copy not implemented correctly")
        
        XCTAssertNotEqual(game.index, copy.index,
            "Deep copy not implemented correctly")
    }
    
    func testEncodeAndDecode() {
        // create test stub
        let grid = GOGrid(width: 50, height: 50, andUnitLength: 1)
        let nodes = [String: XNode]()
        let music = XMusic()
        
        // things to be tested
        let game = GameLevel(levelName: "game1", levelIndex: 50, grid: grid,
            solvedGrid: grid, nodes: nodes, targetMusic: music)
        
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(game, forKey: "test")
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey("test")! as GameLevel
        
        XCTAssertEqual(recoverObj.index, game.index,
            "NSCoding not implemented correctly")
        
        XCTAssertEqual(recoverObj.name, game.name,
            "NSCoding not implemented correctly")
        
        XCTAssertEqual(recoverObj.targetMusic, game.targetMusic,
            "NSCoding not implemented correctly")
    }
}