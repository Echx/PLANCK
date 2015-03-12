//
//  Constant.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

struct Constant {
    static let lightSpeedBase: CGFloat = 800 //points per second
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