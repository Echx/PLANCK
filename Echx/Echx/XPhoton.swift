//
//  XPhoton.swift
//  Echx
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class XPhoton: XNode {
    var illuminance: CGFloat
    var color: XColor
    
    init() {
        illuminance = 0.0
        color = XColor()
    }
    
    init(illuminance: CGFloat, color: XColor) {
        self.illuminance = illuminance
        self.color = color
    }
    
    func getSpeedInMedium(medium: XMedium) -> CGFloat {
        return XConstant.lightSpeedBase / medium.getRefractiveIndex()
    }
}

