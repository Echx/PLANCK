//
//  XColor.swift
//  Echx
//
//  Created by Lei Mingyu on 09/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

struct XColor : Equatable {
    internal var containsRed: Bool
    internal var containsGreen: Bool
    internal var containsBlue: Bool
    internal var displayColor: UIColor {
        get {
            // TODO
            return UIColor.clearColor()
        }
    }
    
    init () {
        self.containsRed = false
        self.containsGreen = false
        self.containsBlue = false
    }
    
    init (containsRed: Bool, containsGreen: Bool, containsBlue: Bool) {
        self.containsRed = containsRed
        self.containsGreen = containsGreen
        self.containsBlue = containsBlue
    }
    
    func containsColor(color: XColor) -> Bool {
        let containsRed = self.containsRed || !color.containsRed
        let containsGreen = self.containsGreen || !color.containsGreen
        let containsBlue = self.containsBlue || !color.containsBlue
        return containsRed && containsGreen && containsBlue
    }
    
}

func + (left: XColor, right: XColor) -> XColor {
    // TODO
    let containsRed = left.containsRed || right.containsRed
    let containsGreen = left.containsGreen || right.containsGreen
    let containsBlue = left.containsBlue || right.containsBlue
    return XColor(containsRed: containsRed, containsGreen: containsGreen, containsBlue: containsBlue)
}

func - (left: XColor, right: XColor) -> XColor {
    // TODO
    let containsRed = left.containsRed && !right.containsRed
    let containsGreen = left.containsGreen && !right.containsGreen
    let containsBlue = left.containsBlue && !right.containsBlue
    return XColor(containsRed: containsRed, containsGreen: containsGreen, containsBlue: containsBlue)
}

func == (left: XColor, right: XColor) -> Bool {
    if (left.containsRed == right.containsRed &&
        left.containsBlue == right.containsBlue &&
        left.containsGreen == right.containsGreen) {
            return true
    } else {
        return false
    }
}
