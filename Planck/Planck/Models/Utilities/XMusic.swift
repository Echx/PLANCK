 //
//  XMusic.swift
//  Planck
//
//  Created by Lei Mingyu on 13/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import Foundation

class XMusic: NSObject, NSCoding {
    var music: [XNote: [CGFloat]]
    var isArranged: Bool // whether the distances are sorted
    var numberOfPlanck: Int
    
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
        self.numberOfPlanck = 0
        self.music = [XNote: [CGFloat]]()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let music = aDecoder.decodeObjectForKey(NSCodingKey.MusicDic) as [XNote: [CGFloat]]
        let isArranged = aDecoder.decodeBoolForKey(NSCodingKey.MusicIsArranged)
        let numberOfPlanck = aDecoder.decodeIntForKey(NSCodingKey.MusicNumberOfPlanck)
        self.init()
        self.music = music
        self.numberOfPlanck = Int(numberOfPlanck)
        self.isArranged = isArranged
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.music, forKey: NSCodingKey.MusicDic)
        aCoder.encodeBool(self.isArranged, forKey: NSCodingKey.MusicIsArranged)
        aCoder.encodeInt(Int32(self.numberOfPlanck), forKey: NSCodingKey.MusicNumberOfPlanck)
    }
    
    func deepCopy() -> XMusic {
        return NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(self)) as XMusic
    }
    
    func reset() {
        self.isArranged = true
        self.numberOfPlanck = 0
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
                self.music[note]?.sort({$0 < $1})
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
                if let anotherPathDistances = anotherMusic.music[noteOccurence.0] {
                    if fabs((Double)(noteOccurence.1[i] - anotherPathDistances[i])) > MusicDefaults.distanceTolerance {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        
        return true
    }
    
    func flattenMapping() -> [(XNote, CGFloat)] {
        var notesArray = [(XNote, CGFloat)]()
        for (note, distances) in self.music {
            for distance in distances {
                notesArray.append((note, distance))
            }
        }
        notesArray.sort({$0.1 <= $1.1})
        
        return notesArray
    }
}
