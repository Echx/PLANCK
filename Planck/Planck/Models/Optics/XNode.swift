//
//  XNode.swift
//  Planck
//
//  Created by Wang Jinghan on 10/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// This class is the parent class of all X-devices
// it provides the common api for instrument-related operation and interaction
// like getting the sound of the instrument, and stores the common property for 
// the nodes, like whether the instrument is tagged as 'Planck', and whether it
// is fixed
class XNode: NSObject, NSCoding {
    
    //physicsBody defines the physics property of the xnode
    //it determines how it behaviors towards the light ray
    var physicsBody: GOOpticRep
    
    //an integer indicating the intrument type of the node
    var instrument: Int = NodeDefaults.instrumentInherit

    //a boolean indicating whether the node has a customized sound (i.e. piano or harp)
    var isPlanck: Bool {
        get {
            if (self.instrument == NodeDefaults.instrumentInherit) || (self.instrument == NodeDefaults.instrumentNil) {
                return false
            } else {
                return true
            }
        }
    }
    
    //a boolean indicating whether the node should play sound when getting hit
    var shouldPlaySound: Bool {
        get {
            if self.instrument == NodeDefaults.instrumentNil {
                return false
            } else {
                return true
            }
        }
    }
    
    //the appearance color of the node
    var strokeColor = UIColor.whiteColor()
    
    //the sound in normal state
    var normalNote: XNote?
    
    //the cutomized sound set by the designer
    var planckNote: XNote?
    
    //a boolean indicating whether the node can be moved in game mode
    var isFixed = true
    
    //the id for the node, which is the same its physicsBody id
    var id: String {
        get {
            return self.physicsBody.id
        }
    }
    
    init(physicsBody: GOOpticRep) {
        self.physicsBody = physicsBody
        super.init()
    }
    
    
    //returns: the url of its corresponding sound file
    func getSound() -> NSURL? {
        if !self.shouldPlaySound {
            return nil
        } else {
            return self.getNote()?.getAudioFile()
        }
    }
    
    //returns: a xnote object representing its sound
    //         nil if the node should not play sound
    func getNote() -> XNote? {
        if !self.shouldPlaySound {
            return nil
        } else if self.isPlanck {
            return self.planckNote
        } else {
            return self.normalNote
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey(NSCodingKey.XNodeBody) as GOOpticRep
        let isFixed = aDecoder.decodeBoolForKey(NSCodingKey.XNodeFixed)
        let planckNote = aDecoder.decodeObjectForKey(NSCodingKey.XNodePlanck) as XNote?
        let instrument = aDecoder.decodeObjectForKey(NSCodingKey.XNodeInstrument) as Int

        self.init(physicsBody: body)
        self.isFixed = isFixed
        self.instrument = instrument
        self.planckNote = planckNote
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: NSCodingKey.XNodeBody)
        aCoder.encodeBool(self.isFixed, forKey: NSCodingKey.XNodeFixed)
        aCoder.encodeObject(self.instrument, forKey: NSCodingKey.XNodeInstrument)
        if self.planckNote != nil {
            aCoder.encodeObject(self.planckNote, forKey: NSCodingKey.XNodePlanck)
        }
    }
}
