//
//  GOConstant.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

struct GOConstant {
    static let angleCalculationPrecision:CGFloat = 1000
    static let overallPrecision: CGFloat = 0.00001
    static let boundaryOffset : CGFloat = 1
    static let vacuumRefractionIndex: CGFloat = 1
}

enum DeviceType: Int {
    case Lens = 0
    case Mirror, Wall, Emitter
}
