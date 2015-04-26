//
//  XFlatMirrorTest.swift
//  Planck
//
//  Created by NULL on 13/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import XCTest

class XFlatMirrorTest: XCTestCase {
    let precision: CGFloat = 1000
    
    var inAngles = [CGVectorMake(0, 1), CGVectorMake(0, -1), CGVectorMake(1, 0),
        CGVectorMake(-1, 0), CGVectorMake(1, 1), CGVectorMake(-1, -1),
        CGVectorMake(1, -1), CGVectorMake(-1, 1)]
    var mirrorsAngle = [CGVectorMake(1, 0), CGVectorMake(-1, 0), CGVectorMake(0, 1),
        CGVectorMake(0, -1), CGVectorMake(1, 1), CGVectorMake(1, -1),
        CGVectorMake(-1, -1), CGVectorMake(-1, 1)]
    
    //one row has the same mirror, one column has the same inAngle
    //expectedOutAngles[inAngle][mirror]
    var expectedOutAngles = [
        [CGVectorMake(0, -1), CGVectorMake(0, -1), CGVectorMake(0, -1),
            CGVectorMake(0, -1), CGVectorMake(1, 0), CGVectorMake(-1, 0),
            CGVectorMake(1, 0), CGVectorMake(-1, 0)],
        [CGVectorMake(0, 1), CGVectorMake(0, 1), CGVectorMake(0, 1),
            CGVectorMake(0, 1), CGVectorMake(-1, 0), CGVectorMake(1, 0), CGVectorMake(-1, 0), CGVectorMake(1, 0)],
        [CGVectorMake(-1, 0), CGVectorMake(-1, 0), CGVectorMake(-1, 0),
            CGVectorMake(-1, 0), CGVectorMake(0, 1), CGVectorMake(0, -1),
            CGVectorMake(0, 1), CGVectorMake(0, -1)],
        [CGVectorMake(1, 0), CGVectorMake(1, 0), CGVectorMake(1, 0),
            CGVectorMake(1, 0), CGVectorMake(0, -1), CGVectorMake(0, 1),
            CGVectorMake(0, -1), CGVectorMake(0, 1)],
        [CGVectorMake(1, -1), CGVectorMake(1, -1), CGVectorMake(-1, 1),
            CGVectorMake(-1, 1), CGVectorMake(-1, -1), CGVectorMake(-1, -1),
            CGVectorMake(-1, -1), CGVectorMake(-1, -1)],
        [CGVectorMake(-1, 1), CGVectorMake(-1, 1), CGVectorMake(1, -1),
            CGVectorMake(1, -1), CGVectorMake(1, 1), CGVectorMake(1, 1),
            CGVectorMake(1, 1), CGVectorMake(1, 1)],
        [CGVectorMake(1, 1), CGVectorMake(1, 1), CGVectorMake(-1, -1),
            CGVectorMake(-1, -1), CGVectorMake(-1, 1), CGVectorMake(-1, 1),
            CGVectorMake(-1, 1), CGVectorMake(-1, 1)],
        [CGVectorMake(-1, -1), CGVectorMake(-1, -1), CGVectorMake(1, 1),
            CGVectorMake(1, 1), CGVectorMake(1, -1), CGVectorMake(1, -1),
            CGVectorMake(1, -1), CGVectorMake(1, -1)],
    ]
    

    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReflectAngle() {
        
        for var i = 0; i < inAngles.count; i++ {
            for var j = 0; j < mirrorsAngle.count; j++ {
                let inAngle = inAngles[i]
                let mirror = XFlatMirror(direction: mirrorsAngle[j])
                let outAngle = mirror.getNewDirectionAfterReflect(inAngle)
                let expectedOutAngle = expectedOutAngles[i][j]
                
                let outAngleX = round(outAngle.dx * precision) / precision
                let outAngleY = round(outAngle.dy * precision) / precision
                let expectedOutAngleX = round(expectedOutAngle.dx * precision) / precision
                let expectedOutAngleY = round(expectedOutAngle.dy * precision) / precision
                
                println("\nTesting: (\(inAngle.dx), \(inAngle.dy)) -> (\(mirrorsAngle[j].dx), \(mirrorsAngle[j].dy))")
                
                if outAngleY == 0 {
                    XCTAssert(outAngleY == expectedOutAngleY, "expected: (\(expectedOutAngleX), \(expectedOutAngleY)) but recieved: (\(outAngleX), \(outAngleY))")
                } else {
                    XCTAssert(outAngleX / outAngleY == expectedOutAngleX / expectedOutAngleY, "expected: (\(expectedOutAngleX), \(expectedOutAngleY)) but recieved: (\(outAngleX), \(outAngleY))")
                }

                println("Finished!\n")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
