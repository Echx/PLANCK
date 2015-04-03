//
//  GOFlatLensRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOFlatLensRep: GOFlatOpticRep {
    override init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, refractionIndex: CGFloat, id: String) {
        super.init(center: center, thickness: thickness, length: length, direction: direction, refractionIndex: refractionIndex, id: id)
        self.setDeviceType(DeviceType.Lens)
    }
}
