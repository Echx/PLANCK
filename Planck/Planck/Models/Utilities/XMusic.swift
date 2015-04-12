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
    var music: [XNote: [CGFloat]]
    var isArranged: Bool // whether the distances are sorted
    
    var numberOfNotes: Int {
        get {
            return self.music.count
        }
    }
    
    var numberOfSounds: Int {
        get {
            var count: Int = 0
            for distanceArray in self.music.values {
                count += distanceArray.count
            }
            return count
        }
    }
    
    override init() {
        self.isArranged = true
        self.music = [XNote: [CGFloat]]()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let music = aDecoder.decodeObjectForKey(NSCodingKey.NoteGroup) as Dictionary<XNote,[CGFloat]>
        let isArranged = aDecoder.decodeBoolForKey("arrange")
        self.init()
        self.music = music
        self.isArranged = isArranged
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.music, forKey: "music")
        aCoder.encodeBool(self.isArranged, forKey: "arrange")
    }
    
    func reset() {
        self.isArranged = true
        self.music = [XNote: [CGFloat]]()
    }
    
    func appendDistance(distance: CGFloat, forNote note: XNote) {
        self.isArranged = false
        
        if self.music[note] == nil {
            self.music[note] = [CGFloat]()
        }
        
        self.music[note]?.append(distance)
    }
    
    private func arrangeDistances() {
        if self.isArranged {
            return
        } else {
            for note in self.music.keys {
                self.music[note]?.sort({$0 > $1})
            }
            
            self.isArranged = true
        }
    }
    
    func isSimilarTo(anotherMusic: XMusic) -> Bool {
        if self.numberOfNotes != anotherMusic.numberOfNotes {
            return false
        }
        
        if self.numberOfSounds != anotherMusic.numberOfSounds {
            return false
        }
        
        self.arrangeDistances()
        anotherMusic.arrangeDistances()
        
        for noteOccurence in self.music {
            for i in 0...noteOccurence.1.count - 1 {
                let anotherPathDistances = anotherMusic.music[noteOccurence.0]!
                if fabs((Double)(noteOccurence.1[i] - anotherPathDistances[i])) > MusicDefaults.distanceTolerance {
                    return false
                }
            }
        }
        
        return true
    }
}
