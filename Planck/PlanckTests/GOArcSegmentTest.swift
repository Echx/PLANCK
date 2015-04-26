//
//  GOArcSegmentTest.swift
//  Planck
//
//  Created by Lei Mingyu on 27/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class GOArcSegmentTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation
        // of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation
        // of each test method in the class.
        super.tearDown()
    }
    
    func testArcSegment() {
        let arcSegment = GOArcSegment(center: CGPointMake(10, 1), radius: 4,
            radian: CGFloat(M_PI), normalDirection: CGVectorMake(1, 0))
        
        println("\n\n\n(\(arcSegment.normalDirection.dx), \(arcSegment.normalDirection.dy))\n\n\n")
        
        var rayOut = arcSegment.getRefractionRay(
            rayIn: GORay(startPoint: CGPointMake(0, 0), direction: CGVectorMake(1, 0)),
            indexIn: 0.2,
            indexOut: 1)
        
        let dev = CGFloat(0.001)
        
        XCTAssertLessThanOrEqual(rayOut!.0.startPoint.x - 14, dev, "WTH")
        
        if rayOut != nil {
            println("\n\n\n(\(rayOut!.0.startPoint.x), \(rayOut!.0.startPoint.y)) --> direction: (\(rayOut!.0.direction.dx), \(rayOut!.0.direction.dy))\n\n\n")
        } else {
            println("\n\n\n nil \n\n\n")
        }
    }
    
    
    func testIntersection() {
        let inputRay = GORay(startPoint: CGPoint(x: 8, y: 7),
            direction: CGVector(dx: 1, dy: 2))
        let mirror = GOLineSegment(center: CGPointMake(10, 8), length: 10,
            direction: CGVector(dx: 1, dy: 0))
        XCTAssertEqual(mirror.isIntersectedWithRay(inputRay), true,
            "They should intersected!")
    }
    
    func testReflection() {
        let inputRay = GORay(startPoint: CGPoint(x: 0, y: 0),
            direction: CGVector(dx: 1, dy: 1))
        let mirror = GOLineSegment(center: CGPointMake(7, 10), length: 10,
            direction: CGVector(dx: 1, dy: 0))
        let outRay = mirror.getReflectionRay(rayIn: inputRay)!
        println("Direction of out array: \(outRay.direction.angleFromXPlus)\n")
        XCTAssertEqual(outRay.direction.angleFromXPlus, CGFloat(7 * M_PI / 4),
            "The reflection ray is wrong!")
    }
    
    
    func testPoint() {
        let arcSegment1 = GOArcSegment(center: CGPointMake(4, 0), radius: 10,
            radian: CGFloat(M_PI), normalDirection: CGVectorMake(-1, 0))
        XCTAssertEqual(arcSegment1.center.x, CGFloat(4), "test point failed")
        XCTAssertEqual(arcSegment1.center.y, CGFloat(0), "test point failed")
        
        XCTAssertEqual(arcSegment1.radius, CGFloat(10), "test point failed")
        
        XCTAssertEqual(arcSegment1.radian, CGFloat(M_PI), "test point failed")
        
        let dev = CGFloat(0.001)
        
        XCTAssertLessThanOrEqual((arcSegment1.startPoint.x - 4).abs, dev,
            "test point failed")
        XCTAssertLessThanOrEqual((arcSegment1.startPoint.y - 10).abs, dev,
            "test point failed")
        XCTAssertLessThanOrEqual((arcSegment1.endPoint.x - 4).abs, dev,
            "test point failed")
        XCTAssertLessThanOrEqual((arcSegment1.startPoint.y - 10).abs, dev,
            "test point failed")
    }
}