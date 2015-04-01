//
//  GOConstant.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

struct Constant {
    static let angleCalculationPrecision:CGFloat = 1000
}

enum DeviceType: Int {
    case Lens = 0
    case Mirror, Wall
}