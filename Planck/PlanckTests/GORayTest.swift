//
//  GORayTest.swift
//  Planck
//
//  Created by Lei Mingyu on 27/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class GORayTest: XCTestCase {
    func testRayGetY() {
        var ray = GORay(startPoint: CGPointMake(0, 0), direction: CGVectorMake(2, 1))
        XCTAssertEqual(ray.getY(x: 4)!, CGFloat(2), "get y wrong")
        XCTAssertEqual(ray.getY(x: 3)!, CGFloat(1.5), "get y wrong")
        XCTAssertTrue(ray.getY(x: -1) == nil, "get y wrong")
    }
    
    func testRayGetX() {
        var ray = GORay(startPoint: CGPointMake(0, 0), direction: CGVectorMake(2, 1))
        XCTAssertEqual(ray.getX(y: 2)!, CGFloat(4), "get x wrong")
        XCTAssertEqual(ray.getX(y: 1.5)!, CGFloat(3), "get x wrong")
        XCTAssertTrue(ray.getX(y: -1) == nil, "get y wrong")
    }
}
