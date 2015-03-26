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
