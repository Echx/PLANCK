//
//  CGVector+XUtilityTest.swift
//  Planck
//
//  Created by Wang Jinghan on 13/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class CGVector_XUtilityTest: XCTestCase {   
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of
        // each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation
        // of each test method in the class.
        super.tearDown()
    }
    
    func testAngleFromXPlus() {
        XCTAssertEqual(CGFloat(M_PI), CGVectorMake(-1, 0).angleFromXPlus,
            "testAngleFromXPlus failed");
        XCTAssertEqual(CGFloat(0), CGVectorMake(1, 0).angleFromXPlus,
            "testAngleFromXPlus failed");
        XCTAssertEqual(CGFloat(M_PI / 2), CGVectorMake(0, 1).angleFromXPlus,
            "testAngleFromXPlus failed");
        XCTAssertEqual(CGFloat(M_PI / 2 * 3), CGVectorMake(0, -1).angleFromXPlus,
            "testAngleFromXPlus failed");
        
        XCTAssertEqual(CGFloat(M_PI / 4), CGVectorMake(1, 1).angleFromXPlus,
            "testAngleFromXPlus failed");
        XCTAssertEqual(CGFloat(M_PI / 4 * 3), CGVectorMake(-1, 1).angleFromXPlus,
            "testAngleFromXPlus failed");
        XCTAssertEqual(CGFloat(M_PI / 4 * 7), CGVectorMake(1, -1).angleFromXPlus,
            "testAngleFromXPlus failed");
        XCTAssertEqual(CGFloat(M_PI / 4 * 5), CGVectorMake(-1, -1).angleFromXPlus,
            "testAngleFromXPlus failed");
    }
    
}


