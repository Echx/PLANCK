//
//  GOFlatWallRep.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOFlatWallRep: GOFlatOpticRep {
    override init(center: GOCoordinate, thickness: NSInteger, length: NSInteger, direction: CGVector) {
        super.init(center: center, thickness: thickness, length: length, direction: direction)
        self.setDeviceType(DeviceType.Wall)
    }
}
