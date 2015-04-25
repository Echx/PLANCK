//
//  XMusicTest.swift
//  Planck
//
//  Created by Jiang Sheng on 25/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class XMusicTest: XCTestCase {
    func testSimilarity() {
        let music1 = XMusic()
        let music2 = XMusic()
        let music3 = XMusic()
        let music4 = XMusic()
        
        let noteA = XNote(noteName: XNoteName.A, noteGroup: 2, instrument: nil)
        let noteB = XNote(noteName: XNoteName.B, noteGroup: 2, instrument: nil)
        let noteC = XNote(noteName: XNoteName.A, noteGroup: 3, instrument: nil)
        let noteD = XNote(noteName: XNoteName.B, noteGroup: 3, instrument: nil)
        let noteE = XNote(noteName: XNoteName.D, noteGroup: 3, instrument: nil)
        
        music1.appendDistance(1.0, forNote: noteA)
        music1.appendDistance(2.0, forNote: noteB)
        music1.appendDistance(3.0, forNote: noteC)
        music1.appendDistance(4.0, forNote: noteD)
        
        music2.appendDistance(1.0, forNote: noteA)
        music2.appendDistance(2.0, forNote: noteB)
        music2.appendDistance(3.0, forNote: noteC)
        music2.appendDistance(4.0, forNote: noteD)
        
        XCTAssertTrue(music1.isSimilarTo(music2), "Two music should be the same!")
        
        music3.appendDistance(4.0, forNote: noteA)
        music3.appendDistance(3.0, forNote: noteB)
        music3.appendDistance(2.0, forNote: noteC)
        music3.appendDistance(1.0, forNote: noteD)
        
        XCTAssertTrue(music1.isSimilarTo(music3), "Two music's difference within tolerance should be similiar!!")
        
        music4.appendDistance(400.0, forNote: noteA)
        music4.appendDistance(300.0, forNote: noteB)
        music4.appendDistance(200.0, forNote: noteE)
        music4.appendDistance(100.0, forNote: noteD)
        
        XCTAssertFalse(music1.isSimilarTo(music4), "Two different music are not similiar!")

    }
    
    func testAppendDistance() {
        let music = XMusic()
        let note = XNote(noteName: XNoteName.A, noteGroup: 2, instrument: nil)
        music.appendDistance(100, forNote: note)
        music.appendDistance(80, forNote: note)
        music.appendDistance(40, forNote: note)
        music.appendDistance(70, forNote: note)
        music.appendDistance(20, forNote: note)
        
        let expectedArray:[CGFloat] = [100, 80, 40, 70, 20]
        let generatedArray = music.music[note]!
        
        XCTAssertEqual(expectedArray, generatedArray, "Two array should have the same append distance")
    }

}
