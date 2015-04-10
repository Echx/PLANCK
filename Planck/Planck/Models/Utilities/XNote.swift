//
//  XNote.swift
//  Planck
//
//  Created by Lei Mingyu on 13/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import Foundation

class XNote: NSObject, NSCoding {
    var noteName: XNoteName
    var noteGroup: Int
    var isPitchedNote: Bool
    
    init(noteName: XNoteName, noteGroup: Int) {
        self.noteName = noteName
        self.noteGroup = noteGroup
        self.isPitchedNote = true
        if contains([XNoteName.cymbal, XNoteName.snareDrum, XNoteName.bassDrum], self.noteName) {
            self.isPitchedNote = false
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let noteNameRaw = aDecoder.decodeObjectForKey(NSCodingKey.NoteName)! as Int
        let noteName = XNoteName(rawValue: noteNameRaw)!
        let noteGroup = aDecoder.decodeObjectForKey(NSCodingKey.NoteGroup)! as Int
        self.init(noteName: noteName, noteGroup: noteGroup)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.noteName.rawValue, forKey: NSCodingKey.NoteName)
        aCoder.encodeObject(self.noteGroup, forKey: NSCodingKey.NoteGroup)
    }
    
    func getMIDINote() -> Int {
        if !self.isPitchedNote {
            return -1
        }
        
        var note: Int = (self.noteGroup + 1) * 12 // base MIDI note
        let baseNote: Int = self.noteName.rawValue / 5
        let accidental: Int = self.noteName.rawValue % 5
        
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
    
    func getImageFileName() -> String {
        if !self.isPitchedNote {
            switch self.noteName {
            case .bassDrum:
                return "bass-drum"
                
            case .snareDrum:
                return "snare-drum"
                
            case .cymbal:
                return "cymbal"
                
            default:
                fatalError("impossible")
            }
        }
        
        var fileName: String = "planck-"
        let baseNote: Int = self.noteName.rawValue / 4
        let accidental: Int = self.noteName.rawValue % 4
        
        switch baseNote {
        case 0:
            // C
            fileName += "c"
            
        case 1:
            // D
            fileName += "d"
            
        case 2:
            // E
            fileName += "e"
            
        case 3:
            // F
            fileName += "f"
            
        case 4:
            // G
            fileName += "g"
            
        case 5:
            // A
            fileName += "a"
            
        case 6:
            // B
            fileName += "b"
            
        default:
            fatalError("invalid note")
        }
        
        switch accidental {
        case 0:
            // natural
            fileName += ""
            
        case 1:
            // flat
            fileName += "b"
            
        case 2:
            // double flat
            fileName += "bb"
            
        case 3:
            // sharp
            fileName += "#"
            
        case 4:
            // double sharp
            fileName += "x"
            
        default:
            fatalError("invalid note")
        }
        
        fileName += String(self.noteGroup)
        
        return fileName
        
    }
    
    func getAudioFileName() -> String {
        
        if !self.isPitchedNote {
            switch self.noteName {
            case .bassDrum:
                return "bass-drum.m4a"
                
            case .snareDrum:
                return "snare-drum.m4a"
                
            case .cymbal:
                return "cymbal.m4a"
                
            default:
                fatalError("impossible")
            }
        }

        return NSString(format: "piano-%d.m4a", self.getMIDINote())
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
    case snareDrum, bassDrum, cymbal
}
