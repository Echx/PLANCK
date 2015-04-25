//
//  XColor.swift
//  Planck
//
//  Created by Lei Mingyu on 09/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

// This class is not used in current project, but it is developed for future use
// This class defined the color used in the project, including the color of rays and xnodes
class XColor : NSObject, Hashable, NSCoding {
    
    let displayColors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        UIColor(red: 0, green: 0, blue: 1, alpha: 1),
        UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 0, alpha: 1),
        UIColor(red: 1, green: 0, blue: 1, alpha: 1),
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),
        UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
    
    var containsRed: Bool
    var containsGreen: Bool
    var containsBlue: Bool
    override var hashValue: Int {
        return displayColor.hashValue
    }
    
    var displayColor: UIColor {
        get {
            var index = 0
            
            if self.containsRed {
                //the third binary bit
                index += 4
            }
            
            if self.containsGreen {
                //the second binary bit
                index += 2
            }
            
            if self.containsBlue {
                //the first binary bit
                index += 1
            }
            
            return displayColors[index]
        }
    }
    
    override init () {
        self.containsRed = false
        self.containsGreen = true
        self.containsBlue = false
    }
    
    init (index: NSInteger) {
        self.containsRed = (index / 4) == 1
        self.containsGreen = (index % 4) / 2 == 1
        self.containsBlue = (index % 2) == 1
    }
    
    init (containsRed: Bool, containsGreen: Bool, containsBlue: Bool) {
        self.containsRed = containsRed
        self.containsGreen = containsGreen
        self.containsBlue = containsBlue
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.containsRed = aDecoder.decodeBoolForKey(NSCodingKey.ColorRed)
        self.containsGreen = aDecoder.decodeBoolForKey(NSCodingKey.ColorGreen)
        self.containsBlue = aDecoder.decodeBoolForKey(NSCodingKey.ColorBlue)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(self.containsRed, forKey: NSCodingKey.ColorRed)
        aCoder.encodeBool(self.containsGreen, forKey: NSCodingKey.ColorGreen)
        aCoder.encodeBool(self.containsBlue, forKey: NSCodingKey.ColorBlue)
    }
    
    //check if self contains the given color components
    func containsColor(color: XColor) -> Bool {
        let containsRed = self.containsRed || !color.containsRed
        let containsGreen = self.containsGreen || !color.containsGreen
        let containsBlue = self.containsBlue || !color.containsBlue
        return containsRed && containsGreen && containsBlue
    }
}

func + (left: XColor, right: XColor) -> XColor {
    let containsRed = left.containsRed || right.containsRed
    let containsGreen = left.containsGreen || right.containsGreen
    let containsBlue = left.containsBlue || right.containsBlue
    return XColor(containsRed: containsRed, containsGreen: containsGreen, containsBlue: containsBlue)
}

func - (left: XColor, right: XColor) -> XColor {
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
