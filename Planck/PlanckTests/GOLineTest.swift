//
//  GOLineTest.swift
//  Planck
//
//  Created by Lei Mingyu on 27/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import XCTest

class GOLineTest: XCTestCase {
    func testLineGetY() {
        var line1 = GOLine(anyPoint: CGPointMake(0, 0), direction: CGVectorMake(2, 1))
        XCTAssertEqual(line1.getY(x: 4)!, CGFloat(2), "get y wrong")
        XCTAssertEqual(line1.getY(x: 3)!, CGFloat(1.5), "get y wrong")
        
        var line2 = GOLine(anyPoint: CGPointMake(0, 0), direction: CGVectorMake(0, 1))
        XCTAssertTrue(line2.getY(x: 4) == nil, "get y wrong")
        XCTAssertEqual(line2.getY(x: 0)!, CGFloat(0), "get y wrong")
        
        var line3 = GOLine(anyPoint: CGPointMake(0, 0), direction: CGVectorMake(1, 0))
        XCTAssertEqual(line3.getY(x: 4)!, CGFloat(0), "get y wrong")
        XCTAssertEqual(line3.getY(x: 0)!, CGFloat(0), "get y wrong")
    }
    
    func testLineGetX() {
        var line1 = GOLine(anyPoint: CGPointMake(0, 0), direction: CGVectorMake(2, 1))
        XCTAssertEqual(line1.getX(y: 2)!, CGFloat(4), "get y wrong")
        XCTAssertEqual(line1.getX(y: 1.5)!, CGFloat(3), "get y wrong")
        
        var line2 = GOLine(anyPoint: CGPointMake(0, 0), direction: CGVectorMake(1, 0))
        XCTAssertTrue(line2.getX(y: 2) == nil, "get y wrong")
        XCTAssertTrue(line2.getX(y: 0) == CGFloat(0), "get y wrong")
        XCTAssertEqual(line2.getX(y: 0)!, CGFloat(0), "get y wrong")
        
        var line3 = GOLine(anyPoint: CGPointMake(0, 0), direction: CGVectorMake(0, 1))
        XCTAssertEqual(line3.getX(y: 2)!, CGFloat(0), "get y wrong")
        XCTAssertEqual(line3.getX(y: 0)!, CGFloat(0), "get y wrong")
    }
    
    func testLineIntersection() {
        var line1 = GOLine(anyPoint: CGPointMake(1, 0), direction: CGVectorMake(1, 1))
        var line2 = GOLine(anyPoint: CGPointMake(0, 2), direction: CGVectorMake(1, -1))
        XCTAssertEqual(GOLine.getIntersection(line1: line1, line2: line2)!,
            CGPointMake(1.5, 0.5), "get y wrong")
        
        var line3 = GOLine(anyPoint: CGPointMake(1, 0), direction: CGVectorMake(0, 1))
        var line4 = GOLine(anyPoint: CGPointMake(0, 2), direction: CGVectorMake(1, 0))
        XCTAssertEqual(GOLine.getIntersection(line1: line3, line2: line4)!,
            CGPointMake(1, 2), "get y wrong")
        XCTAssertEqual(GOLine.getIntersection(line1: line4, line2: line3)!,
            CGPointMake(1, 2), "get y wrong")
    }
}

