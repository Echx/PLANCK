//
//  GOFlatLensRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOFlatLensRep: GOFlatOpticRep {
    override init(center: GOCoordinate, thickness: NSInteger, length: NSInteger, direction: CGVector) {
        super.init(center: center, thickness: thickness, length: length, direction: direction)
        self.setDeviceType(DeviceType.Lens)
    }
}
