//
//  UIFont+Akagi.swift
//  Planck
//
//  Created by Wang Jinghan on 15/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

extension UIFont {
    class func systemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: SystemDefault.planckFont, size: fontSize)!
    }
    
    class func boldSystemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: SystemDefault.planckFontBold, size: fontSize)!
    }
}
