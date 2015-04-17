//
//  GameStats.swift
//  Planck
//
//  Created by Jiang Sheng on 14/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import Foundation

class GameStats: NSObject {
    /// Try set up basic game statistic if necessary
    class func setUp() {
        let defaults = NSUserDefaults.standardUserDefaults()
    }
    
    class func setFirstTime() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: XStats.firstTime)
    }
    
    class func setNotFirstTime() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: XStats.firstTime)
    }
    
    class func isNotFirstTime() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(XStats.firstTime)
    }
    
    class func saveTotalScore(scores:Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(scores, forKey: XStats.totalScore)
    }
    
    class func getTotalScore() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalScore)
    }
    
    
    
    
    
}
