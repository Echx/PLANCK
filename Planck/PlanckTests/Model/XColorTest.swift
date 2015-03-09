//
//  XColorTest.swift
//  Planck
//
//  Created by Jiang Sheng on 10/3/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class XColorTest: XCTestCase {
    
    let pureRed = XColor(containsRed: true, containsGreen: false, containsBlue: false)
    let pureGreen = XColor(containsRed: false, containsGreen: true, containsBlue: false)
    let pureBlue = XColor(containsRed: false, containsGreen: false, containsBlue: true)
    
    func testRed() {
        let redColor1 = XColor(containsRed: true, containsGreen: false, containsBlue: false)
        let redColor2 = XColor(containsRed: true, containsGreen: false, containsBlue: false)
        let resultedColor = redColor1 + redColor2
        
        XCTAssertEqual(resultedColor, pureRed, "Red + Red should be red!")
    }
    
    func testGreen() {
        let greenColor1 = XColor(containsRed: false, containsGreen: true, containsBlue: false)
        let greenColor2 = XColor(containsRed: false, containsGreen: true, containsBlue: false)
        let resultedColor = greenColor1 + greenColor2
        
        XCTAssertEqual(resultedColor, pureGreen, "Green + Green should be Green!")
    }
    
    func testBlue() {
        let blueColor1 = XColor(containsRed: false, containsGreen: false, containsBlue: true)
        
        let blueColor2 = XColor(containsRed: false, containsGreen: false, containsBlue: true)
        
        let resultedColor = blueColor1 + blueColor2

        XCTAssertEqual(resultedColor, pureBlue, "Blue + Blue should be Blue!")
    }
    
    func testYellow() {
        let yellowColor = XColor(containsRed: true, containsGreen: false, containsBlue: false)
    }
    
    func testCyan() {
        let cyanColor = XColor(containsRed: true, containsGreen: false, containsBlue: false)
    }
    
    func testMagenta() {
        let magentaColor = XColor(containsRed: true, containsGreen: false, containsBlue: false)
    }
    
    func testWhite() {
        let whiteColor = XColor(containsRed: true, containsGreen: false, containsBlue: false)
    }
}
