//
//  XMusic.swift
//  Planck
//
//  Created by Lei Mingyu on 13/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import Foundation

class XMusic: NSObject {
    private var music: [XNote: [CGFloat]]
    
    init() {
        self.music = [XNote: [CGFloat]]()
    }
    
    func reset() {
        self.music = [XNote: [CGFloat]]()
    }
    
    func appendDistance(distance: CGFloat, forNote: XNote) {
        if self.music[note] == nil {
            self.music[note] = [CGFloat]()
        }
        
        self.music[note]?.append(self.pathDistances[tag]!)
    }
}
