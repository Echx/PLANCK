//
//  File.swift
//  Echx
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

enum XMedium: Int {
    case Vacuum = 0
    case Air, Water, OliveOil, CrownGlass, FlintGlass
    
    func getRefractiveIndex() -> CGFloat {
        switch self {
            
        case .Vacuum:
            return 1
            
        case .Air:
            return 1.000293
            
        case .Water:
            return 1.333
            
        case .OliveOil:
            return 1.47
            
        case .CrownGlass:
            return 1.52
            
        case .FlintGlass:
            return 1.62
        }
    }
    
    func getDescription() -> String {
        // TODO
        return ""
    }
}
