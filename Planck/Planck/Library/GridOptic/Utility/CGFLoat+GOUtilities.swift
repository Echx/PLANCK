//
//  CGFLoat+GOUtilities.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

extension CGFloat {
    var abs: CGFloat {
        return self < 0 ? -self : self
    }
    
    var restrictWithin2Pi: CGFloat {
        var result = self
        if result < 0 {
            result = CGFloat(M_PI * 2.0) + result
        }
        
        if result > CGFloat(M_PI * 2.0) {
            result = result % CGFloat(M_PI * 2.0)
        }
        
        return result
    }
    
    func equalWithPrecision(f: CGFloat) -> Bool{
        if self - f < GOConstant.overallPrecision {
            return true
        } else {
            return false
        }
    }
}