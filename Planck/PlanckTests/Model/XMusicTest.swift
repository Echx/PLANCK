//
//  XMusicTest.swift
//  Planck
//
//  Created by Lei Mingyu on 13/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class XMusicTest: XCTestCase {
    func testSimilarity() {
        let music1 = XMusic()
        let music2 = XMusic()
        
        let note1 = XNote(noteName: XNoteName.snareDrum, noteGroup: nil, instrument: nil)
        let note2 = XNote(noteName: XNoteName.FDoubleSharp, noteGroup: 5, instrument: NodeDefaults.instrumentHarp)
        
        XCTAssertTrue(music1.isSimilarTo(music2), "they should be similar")
        
        music1.appendDistance(CGFloat(400), forNote: note1)
        
        XCTAssertFalse(music1.isSimilarTo(music2), "they should be different")
        
        music2.appendDistance(CGFloat(399.9), forNote: note1)
        
        XCTAssertTrue(music1.isSimilarTo(music2), "they should be similar")
        
        music1.appendDistance(CGFloat(123), forNote: note1)
        music2.appendDistance(CGFloat(623.5), forNote: note2)
        music2.appendDistance(CGFloat(122.8), forNote: note1)
        
        XCTAssertFalse(music1.isSimilarTo(music2), "they should be different")
        
        music1.appendDistance(CGFloat(623.4), forNote: note2)
        
        XCTAssertTrue(music1.isSimilarTo(music2), "they should be similar")
        
        music1.appendDistance(CGFloat(800), forNote: note1)
        music2.appendDistance(CGFloat(810), forNote: note1)
        
        XCTAssertFalse(music1.isSimilarTo(music2), "they should be different")
    }
}

