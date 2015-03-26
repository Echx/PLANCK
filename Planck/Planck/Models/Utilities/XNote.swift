//
//  XNote.swift
//  Planck
//
//  Created by Lei Mingyu on 13/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class XNote: NSObject {
    var noteName: XNoteName
    var noteGroup: Int
    
    init(noteName: XNoteName, noteGroup: Int) {
        self.noteName = noteName
        self.noteGroup = noteGroup
    }
    
    func getMIDINote() -> Int {
        var note: Int = (self.noteGroup + 1) * 12 // base MIDI note
        let baseNote: Int = self.noteName.rawValue / 4
        let accidental: Int = self.noteName.rawValue % 4
        
        switch baseNote {
        case 0:
            // C
            note += 0
            
        case 1:
            // D
            note += 2
            
        case 2:
            // E
            note += 4
            
        case 3:
            // F
            note += 5
            
        case 4:
            // G
            note += 7
            
        case 5:
            // A
            note += 9
            
        case 6:
            // B
            note += 11
            
        default:
            fatalError("invalid note")
        }
        
        switch accidental {
        case 0:
            // natural
            note += 0
            
        case 1:
            // flat
            note -= 1
            
        case 2:
            // double flat
            note -= 2
            
        case 3:
            // sharp
            note += 1
            
        case 4:
            // double sharp
            note += 2
            
        default:
            fatalError("invalid note")
        }
        
        return note
    }
}

enum XNoteName: Int {
    case C = 0, CFlat, CDoubleFlat, CSharp, CDoubleSharp
    case D, DFlat, DDoubleFlat, DSharp, DDoubleSharp
    case E, EFlat, EDoubleFlat, ESharp, EDoubleSharp
    case F, FFlat, FDoubleFlat, FSharp, FDoubleSharp
    case G, GFlat, GDoubleFlat, GSharp, GDoubleSharp
    case A, AFlat, ADoubleFlat, ASharp, ADoubleSharp
    case B, BFlat, BDoubleFlat, BSharp, BDoubleSharp
}
