//
//  GOEmitterRep.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOEmitterRep: GOFlatOpticRep {
    override init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, id: String) {
        super.init(center: center, thickness: thickness, length: length, direction: direction, id: id)
        self.setDeviceType(DeviceType.Emitter)
    }
}
