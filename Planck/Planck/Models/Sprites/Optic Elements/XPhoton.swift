//
//  XPhoton.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class XPhoton: XNode {
    var illuminance: CGFloat
    var appearanceColor: XColor
    
    override init() {
        illuminance = 0.0
        appearanceColor = XColor()
        super.init()
        
    }
    
    init(illuminance: CGFloat, color: XColor) {
        self.illuminance = illuminance
        self.appearanceColor = color
        super.init()
    }
    
    func getSpeedInMedium(medium: XMedium) -> CGFloat {
        return XConstant.lightSpeedBase / medium.getRefractiveIndex()
    }
}

