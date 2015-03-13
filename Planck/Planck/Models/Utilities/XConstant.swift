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
    static let angleCalculationPrecision: CGFloat = 1000 //1000 is 3 bit precision
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
    static let fireFrequency: Double = 20 //measured in photons/second
}

struct MirrorDefaults {
    static let flatMirrorSize = CGSizeMake(20, 100)
    static let textureColor = UIColor.blackColor()
}

struct WallDefaults {
    static let wallSize = CGSizeMake(20, 500)
    static let textureColor = UIColor.blackColor()
}

struct PlanckDefaults {
    static let planckRadius: CGFloat = 20
    static let planckSize = CGSizeMake(PlanckDefaults.planckRadius * 2, PlanckDefaults.planckRadius * 2)
    static let textureColor = UIColor.blackColor()
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = 0x1 << 31
    static let photon: UInt32 = 0x1 << 0
    static let flatMirror: UInt32 = 0x1 << 1
    static let planck: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
}

struct MediumDescription {
    static let vacuumDescription: String = "Vacuum is space that is devoid of matter."
    static let airDesciption: String = "Air is a layer of gases surrounding the planet Earth that is retained by Earth's gravity."
    static let waterDescription: String = "Water is a transparent fluid which forms the world's streams, lakes, oceans and rain."
    static let oliveOilDescription: String = "Olive oil is a fat obtained from the the fruit of Olea europaea, a traditional tree crop of the Mediterranean Basin."
    static let crownGlassDescription: String = "Crown glass is a type of optical glass used in lenses and other optical components. It has relatively low refractive index (≈1.52) and low dispersion (with Abbe numbers around 60). Crown glass is produced from alkali-lime (RCH) silicates containing approximately 10% potassium oxide and is one of the earliest low dispersion glasses."
    static let flintGlassDescription: String = "Flint glass is optical glass that has relatively high refractive index and low Abbe number (high dispersion). Flint glasses are arbitrarily defined as having an Abbe number of 50 to 55 or less. The currently known flint glasses have refractive indices ranging between 1.45 and 2.00."
    
}