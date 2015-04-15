//
//  UIFont+Akagi.swift
//  Planck
//
//  Created by NULL on 15/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

extension UIFont {
    class func systemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Akagi-Book", size: fontSize)!
    }
    
    class func boldSystemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Akagi-SemiBold", size: fontSize)!
    }
}
