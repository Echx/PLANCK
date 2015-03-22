//
//  InstrumentNSCodingTests
//  Planck
//
//  Created by Jiang Sheng on 22/3/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class InstrumentNSCodingTests : XCTestCase {
    private let defaultLocation = CGPointMake(512, 512)
    private let defaultDirection = CGVector(dx: 1, dy: 0)
    private let defaultColor = XColor(index: 5)
    private let defaultFocus: CGFloat = 5.0
    
    private let EmitterKey = "EMITTER"
    private let PlanckKey = "PLANCK"
    private let FlatLenKey = "FLATLEN"
    private let ConvexLenKey = "CONVEXLEN"
    private let FlatMirrorKey = "FLATMIRW"
    private let WallKey = "WALL"
    // Test NSCoding for each Instruments
    func testEmitterCoding() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        let emitter = XEmitter(appearanceColor: defaultColor,
                               direction: defaultDirection)
        emitter.position = defaultLocation
        archiver.encodeObject(emitter, forKey: EmitterKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(EmitterKey)! as XEmitter
        XCTAssertEqual(recoverObj.direction, defaultDirection, "Error Recovering")
        XCTAssertEqual(recoverObj.appearanceColor, defaultColor, "Error Recovering")
        XCTAssertEqual(recoverObj.position, defaultLocation, "Error Recovering")
    }
    
    func testPlanckCoding() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        let planck = XPlanck()
        planck.position = defaultLocation
        archiver.encodeObject(planck, forKey: PlanckKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(PlanckKey)! as XPlanck
        XCTAssertEqual(recoverObj.position, defaultLocation, "Error Recovering")
    }
    
    func testFlatLenCoding() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        let flatLen = XFlatLens(direction: defaultDirection,
                                medium1: XMedium.Water,
                                medium2: XMedium.Vacuum)
        
        flatLen.position = defaultLocation
        archiver.encodeObject(flatLen, forKey: FlatLenKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(FlatLenKey)! as XFlatLens
        XCTAssertEqual(recoverObj.direction, defaultDirection, "Error Recovering")
        XCTAssertEqual(recoverObj.position, defaultLocation, "Error Recovering")
        XCTAssertEqual(recoverObj.medium1, XMedium.Water, "Error Recovering")
        XCTAssertEqual(recoverObj.medium2, XMedium.Vacuum, "Error Recovering")
    }
    
    func testConvexLenCoding() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        let convexLens = XConvexLens(focus: defaultFocus,
                                     direction: defaultDirection,
                                     medium: XMedium.Water)
        
        convexLens.position = defaultLocation
        archiver.encodeObject(convexLens, forKey: ConvexLenKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(ConvexLenKey)! as XConvexLens
        
        XCTAssertEqual(recoverObj.focus, defaultFocus, "Error Recovering")
        XCTAssertEqual(recoverObj.direction, defaultDirection, "Error Recovering")
        XCTAssertEqual(recoverObj.position, defaultLocation, "Error Recovering")
        XCTAssertEqual(recoverObj.medium, XMedium.Water, "Error Recovering")
    }
    
    func testFlatMirrorCoding() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        let flatMirror = XFlatMirror(direction: defaultDirection)
        
        flatMirror.position = defaultLocation
        archiver.encodeObject(flatMirror, forKey: FlatMirrorKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(FlatMirrorKey)! as XFlatMirror
        
        XCTAssertEqual(recoverObj.direction, defaultDirection, "Error Recovering")
        XCTAssertEqual(recoverObj.position, defaultLocation, "Error Recovering")
    }
    
    func testWallCoding() {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        let wall = XWall(direction: defaultDirection)
        
        wall.position = defaultLocation
        archiver.encodeObject(wall, forKey: WallKey)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let recoverObj = unarchiver.decodeObjectForKey(WallKey)! as XWall
        XCTAssertEqual(recoverObj.direction, defaultDirection, "Error Recovering")
        XCTAssertEqual(recoverObj.position, defaultLocation, "Error Recovering")
    }
}

