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
    class func reset() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: XStats.totalFireLight)
        defaults.setInteger(0, forKey: XStats.totalGamePlay)
        defaults.setInteger(0, forKey: XStats.totalMusicPlayed)
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
    
    class func increaseTotalMusicPlayed() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldTotal = defaults.integerForKey(XStats.totalMusicPlayed)
        oldTotal++
        defaults.setInteger(oldTotal, forKey: XStats.totalMusicPlayed)
    }
    
    class func getTotalMusicPlayed() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalMusicPlayed)
    }
    
    class func increaseTotalGamePlay() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldTotal = defaults.integerForKey(XStats.totalGamePlay)
        oldTotal++
        defaults.setInteger(oldTotal, forKey: XStats.totalGamePlay)
    }
    
    class func getTotalGamePlay() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalGamePlay)
    }
    
    class func increaseTotalLightFire() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldTotal = defaults.integerForKey(XStats.totalFireLight)
        oldTotal++
        defaults.setInteger(oldTotal, forKey: XStats.totalFireLight)
    }
    
    class func getTotalLightFire() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalFireLight)
    }

}
