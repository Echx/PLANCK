//
//  ArchiveTest.swift
//  Planck
//
//  Created by Jiang Sheng on 5/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest
import Foundation

class ArchiveTest : XCTestCase {

    struct Default {
        static let center = GOCoordinate(x: 60, y: 35)
        static let thick  = CGFloat(2)
        static let length = CGFloat(6)
        static let direction = CGVectorMake(1, 1)
        static let index = CGFloat(1.33)
        static let curRadius = CGFloat(8)
        static let thickCenter = CGFloat(8)
        static let thickEdge = CGFloat(8)
        static let GridKey = "GRID"
        static let MirrorKey = "MIRROR_1"
        static let FlatLenKey = "FLAT_LENS_1"
        static let CaveLenKey = "CONCAVE_LENS_1"
        static let VexLenKey1 = "CONVEX_LENS_1"
        static let VexLenKey2 = "CONVEX_LENS_2"
    }
    
    let mirror = GOFlatMirrorRep(center: Default.center , thickness: Default.thick, length: Default.length, direction: Default.direction, id: Default.MirrorKey)
    
    let flatLens = GOFlatLensRep(center: Default.center, thickness: Default.thick, length: Default.length, direction: Default.direction, refractionIndex: Default.index, id: Default.FlatLenKey)
    
    let concaveLens = GOConcaveLensRep(center: GOCoordinate(x: 44, y: 33), direction: CGVectorMake(0, 1), thicknessCenter: 1, thicknessEdge: 4, curvatureRadius: 5, id: "CONCAVE_LENS_1", refractionIndex: 1.50)
    
    let convexLens = GOConvexLensRep(center: GOCoordinate(x: 35, y: 26), direction: CGVectorMake(0, -1), thickness: 3, curvatureRadius: 20, id: "CONVEX_LENS_1", refractionIndex: 1.50)
    
    let convexLens1 = GOConvexLensRep(center: GOCoordinate(x: 15, y: 25), direction: CGVectorMake(1, -1), thickness: 3, curvatureRadius: 8, id: "CONVEX_LENS_2", refractionIndex: 1.50)
    
    func testArchiveGOGrid() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        var grid:GOGrid = GOGrid(width: 64, height: 48, andUnitLength: 16)
    
        grid.addInstrument(mirror)
        
        grid.addInstrument(flatLens)
        
        grid.addInstrument(concaveLens)
        
        grid.addInstrument(convexLens)
        
        grid.addInstrument(convexLens1)

        
        archiver.encodeObject(grid, forKey: Default.GridKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(Default.GridKey)! as GOGrid
        XCTAssertEqual(recoverObj.width , 64, "Error Recovering")
        XCTAssertEqual(recoverObj.height, 48, "Error Recovering")
        XCTAssertEqual(recoverObj.instruments.count , 5, "Error Recovering")
        XCTAssertEqual(recoverObj.unitLength, CGFloat(16), "Error Recovering")
    }
    
    func testArchiveMirror() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(mirror, forKey: Default.MirrorKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(Default.MirrorKey)! as GOFlatMirrorRep
        XCTAssertEqual(recoverObj.center.x, Default.center.x, "Error Recovering")
        XCTAssertEqual(recoverObj.center.y, Default.center.y, "Error Recovering")
        XCTAssertEqual(recoverObj.thickness, Default.thick, "Error Recovering")
        XCTAssertEqual(recoverObj.length , Default.length, "Error Recovering")
        XCTAssertEqual(recoverObj.direction, Default.direction, "Error Recovering")
        XCTAssertEqual(recoverObj.id, Default.MirrorKey, "Error Recovering")
    }
    
    func testArchiveGameLevel() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        var grid:GOGrid = GOGrid(width: 64, height: 48, andUnitLength: 16)
        
        grid.addInstrument(mirror)
        
        grid.addInstrument(flatLens)
        
        grid.addInstrument(concaveLens)
        
        grid.addInstrument(convexLens)
        
        grid.addInstrument(convexLens1)

        let gameLevel = GameLevel(levelName: "haha", levelIndex: 12, grid: grid)
        archiver.encodeObject(gameLevel, forKey: "game")
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey("game")! as GameLevel
        XCTAssertEqual(recoverObj.name, "haha", "Error Recovering")
        XCTAssertEqual(recoverObj.index, 12, "Error Recovering")
        XCTAssertEqual(recoverObj.grid.instruments.count, grid.instruments.count, "Error Recovering")
    }


}
