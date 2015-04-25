//
//  XNoteTest.swift
//  Planck
//
//  Created by Jiang Sheng on 25/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import XCTest

class XNoteTest: XCTestCase {
    func testGetMIDINote() {
        let notPitchNote = XNote(noteName: XNoteName.bassDrum, noteGroup: nil, instrument: nil)
        
        XCTAssertEqual(notPitchNote.getMIDINote(), -1, "A non-pitch note should return -1")
        
        let noteA = XNote(noteName: XNoteName.A, noteGroup: 2, instrument: nil)
        XCTAssertEqual(noteA.getMIDINote(), 45, "note A should return -1")
    }
    
    func testEquatable() {
        let notPitchNote = XNote(noteName: XNoteName.bassDrum, noteGroup: nil, instrument: nil)
        
        let noteA = XNote(noteName: XNoteName.A, noteGroup: 2, instrument: nil)
        let noteAprime = XNote(noteName: XNoteName.A, noteGroup: 2, instrument: nil)
        let noteB = XNote(noteName: XNoteName.A, noteGroup: 3, instrument: nil)
        
        XCTAssertEqual(noteA, noteAprime, "Two note shoud be same")
        
        XCTAssertNotEqual(noteA, noteB, "Two note shoud be different")
    }
}
