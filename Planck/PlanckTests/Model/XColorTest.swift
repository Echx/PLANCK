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
    let pureYellow = XColor(containsRed: true, containsGreen: true, containsBlue: false)
    let pureCyan = XColor(containsRed: false, containsGreen: true, containsBlue: true)
    let pureMagenta = XColor(containsRed: true, containsGreen: false, containsBlue: true)
    
    let pureWhite = XColor(containsRed: true, containsGreen: true, containsBlue: true)
    
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
        let greenColor = XColor(containsRed: false, containsGreen: true, containsBlue: false)
        let redColor = XColor(containsRed: true, containsGreen: false, containsBlue: false)
        
        let resultedYellow = redColor + greenColor
        
        XCTAssertEqual(resultedYellow, pureYellow,
                        "green + red should be yellow!")
        
        XCTAssertEqual(resultedYellow + resultedYellow, pureYellow,
                        "yellow + yellow should be yellow!")
        
        XCTAssertEqual(pureYellow + pureRed, pureYellow,
                        "yellow + red should be yellow!")
        XCTAssertEqual(pureYellow + pureGreen, pureYellow,
                        "yellow + green should be yellow!")
    }
    
    func testCyan() {
        let greenColor = XColor(containsRed: false, containsGreen: true, containsBlue: false)
        let blueColor = XColor(containsRed: false, containsGreen: false, containsBlue: true)
        
        let resultedCyan = greenColor + blueColor
        
        XCTAssertEqual(resultedCyan, pureCyan,
                        "green + blue should be cyan!")
        
        XCTAssertEqual(resultedCyan + resultedCyan, pureCyan,
                        "cyan + cyan should be cyan!")
        
        XCTAssertEqual(pureBlue + pureCyan, pureCyan,
                        "cyan + blue should be cyan!")

        XCTAssertEqual(pureCyan + pureGreen, pureCyan,
                        "cyan + green should be cyan!")
    }
    
    func testMagenta() {
        let redColor = XColor(containsRed: true, containsGreen: false, containsBlue: false)
        let blueColor = XColor(containsRed: false, containsGreen: false, containsBlue: true)
        
        let resultedMagenta = redColor + blueColor
        
        XCTAssertEqual(resultedMagenta, pureMagenta,
                        "red + blue should be Magenta!")
        
        XCTAssertEqual(resultedMagenta + resultedMagenta, pureMagenta,
                        "Magenta + Magenta should be Magenta!")
        
        XCTAssertEqual(pureBlue + pureMagenta, pureMagenta,
                        "Magenta + blue should be Magenta!")
        
        XCTAssertEqual(pureRed + pureMagenta, pureMagenta,
                        "Magenta + green should be Magenta!")
    }
    
    func testWhite() {
        XCTAssertEqual(pureRed + pureCyan, pureWhite,
            "red + cyan should be white!")
        XCTAssertEqual(pureRed + pureWhite, pureWhite,
            "red + white should be white!")
        
        XCTAssertEqual(pureGreen + pureMagenta, pureWhite,
            "green + magenta should be white!")
        XCTAssertEqual(pureGreen + pureWhite, pureWhite,
            "green + white should be white!")
        
        XCTAssertEqual(pureBlue + pureYellow, pureWhite,
            "blue + yellow should be white!")
        XCTAssertEqual(pureBlue + pureWhite, pureWhite,
            "blue + white should be white!")
        
        XCTAssertEqual(pureCyan + pureMagenta, pureWhite,
            "cyan + magenta should be white!")
        XCTAssertEqual(pureCyan + pureYellow, pureWhite,
            "cyan + yellow should be white!")
        XCTAssertEqual(pureCyan + pureWhite, pureWhite,
            "cyan + white should be white!")
        
        XCTAssertEqual(pureMagenta + pureYellow, pureWhite,
            "magenta + yellow should be white!")
        XCTAssertEqual(pureMagenta + pureWhite, pureWhite,
            "magenta + white should be white!")
        
        XCTAssertEqual(pureYellow + pureWhite, pureWhite,
            "yellow + white should be white!")
        
        XCTAssertEqual(pureWhite + pureWhite, pureWhite,
            "white + white should be white!")
    }
}
