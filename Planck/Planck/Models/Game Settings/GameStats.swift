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
    
    /// Set the status to be the first time play the game
    class func setFirstTime() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: XStats.firstTime)
    }
    
    /// query the status if it is the first time play the game
    class func isNotFirstTime() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(XStats.firstTime)
    }
    
    /// Increase the times the target has been played
    class func increaseTotalMusicPlayed() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldTotal = defaults.integerForKey(XStats.totalMusicPlayed)
        oldTotal++
        defaults.setInteger(oldTotal, forKey: XStats.totalMusicPlayed)
    }
    
    /// Get the times the target has been played
    class func getTotalMusicPlayed() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalMusicPlayed)
    }
    
    /// Increase the total times the games has been played
    class func increaseTotalGamePlay() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldTotal = defaults.integerForKey(XStats.totalGamePlay)
        oldTotal++
        defaults.setInteger(oldTotal, forKey: XStats.totalGamePlay)
    }
    
    /// Get the total times that the game has been played
    class func getTotalGamePlay() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalGamePlay)
    }
    
    /// Increase the total times the light has been fired
    class func increaseTotalLightFire() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldTotal = defaults.integerForKey(XStats.totalFireLight)
        oldTotal++
        defaults.setInteger(oldTotal, forKey: XStats.totalFireLight)
    }
    
    /// Get the total times that the light has been fired
    class func getTotalLightFire() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(XStats.totalFireLight)
    }

}
