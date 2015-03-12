//
//  Constant.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

struct Constant {
    static let lightSpeedBase: CGFloat = 1000 //points per second
}

struct ActionKey {
    static let photonActionLinear = "PHOTON_ACTION_KEY_LINEAR"
}

struct NodeName {
    static let xPhoton = "X_PHOTON"
}

struct PhotonDefaults {
    static let diameter: CGFloat = 10    //measured in points
    static let illuminance: CGFloat = 1.0   //0.0 to 1.0
    static let appearanceColor = XColor()
    static let direction = CGVector.zeroVector
    static let textureImageName = "photon"
    static let textureColor = UIColor.blackColor()
}

struct EmitterDefualts {
    static let textureImageName = "emitter"
    static let textureColor = UIColor.blackColor()
    static let diameter: CGFloat = 50
    static let fireFrequency: Double = 10 //measured in photons/second
}

struct MirrorDefaults {
    static let flatMirrorSize = CGSizeMake(20, 100)
    static let textureColor = UIColor.blackColor()
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = 0x1 << 31
    static let photon: UInt32 = 0x1 << 0
    static let flatMirror: UInt32 = 0x1 << 1
}