//
//  HomeViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: XViewController {
    private let emitterView = UIView(frame: UIScreen.mainScreen().bounds)
    private let backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: SoundFiles.backgroundMusic, error: nil)
    
    class func getInstance() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Home
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as HomeViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(self.emitterView, atIndex: 1)
        self.emitterView.alpha = 0
        
        self.playMusic()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopPlayingMusic:", name: HomeViewDefaults.stopPlayingKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startPlayingMusic:", name: HomeViewDefaults.startPlayingKey, object: nil)
        
        let gamiCent = GamiCent.sharedInstance({
            (isAuthentified) -> Void in
            if isAuthentified {
                /* Success! */
                let player = GamiCent.getPlayer()
                
                // report the first achievement here
                dispatch_async(dispatch_get_main_queue(), {
                    if !GameStats.isNotFirstTime() {
                        GamiCent.reportAchievements(percent: 100.0, achievementID: XGameCenter.achi_newbie, isShowBanner: true, completion: nil)
                        GameStats.setNotFirstTime()
                    }
                    GamiCent.reportScoreLeaderboard(leaderboardID: XGameCenter.leaderboardID, score: GameLevel.countTotalScore(), completion: { success in
                        
                    })
                })
                
            } else {
                /* Failed. */
                /* No internet connection? not authentified? */
                println("Failed!!!")
            }
        })
        /* Set delegate */
        GamiCent.delegate = self
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "setUpAnimation:", userInfo: nil, repeats: true)
    }

    private var count = 0;
    func setUpAnimation(timer: NSTimer) {
//        if count > 4 {
//            timer.invalidate()
//            UIView.animateWithDuration(2, animations: {
//                self.emitterView.alpha = 1
//            })
//            return
//        }
//        
//        count++
//        
//        setUpRestAnimation()
//        let emitterLayer = ParticleManager.getHomeBackgroundParticles("FireSpark", longtitude: CGFloat(M_PI * 0.8))
//        emitterView.layer.addSublayer(emitterLayer)
//        var animation = CABasicAnimation(keyPath: "emitterPosition")
//        animation.fromValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionStart)
//        animation.toValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionCenter)
//        animation.duration = CFTimeInterval(2)
//        animation.repeatCount = MAXFLOAT
//        animation.removedOnCompletion = false
//        emitterLayer.addAnimation(animation, forKey: "first-half")
    }
    
    func setUpRestAnimation() {
//        setUpAnimationRed()
//        setUpAnimationOrange()
//        setUpAnimationYellow()
    }

    func setUpAnimationRed() {
        let emitterLayerRed = ParticleManager.getHomeBackgroundParticles("FireSparkRed", longtitude: CGFloat(M_PI * 0.9))
        emitterView.layer.addSublayer(emitterLayerRed)
        var animation = CABasicAnimation(keyPath: "emitterPosition")
        animation.fromValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionCenter)
        animation.toValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionEndRed)
        animation.duration = CFTimeInterval(2)
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        emitterLayerRed.addAnimation(animation, forKey: "second-half-red")
    }
    
    func setUpAnimationOrange() {
        let emitterLayerOrange = ParticleManager.getHomeBackgroundParticles("FireSparkOrange", longtitude: CGFloat(M_PI * 0.9))
        emitterView.layer.addSublayer(emitterLayerOrange)
        var animation = CABasicAnimation(keyPath: "emitterPosition")
        animation.fromValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionCenter)
        animation.toValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionEndOrange)
        animation.duration = CFTimeInterval(2)
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        emitterLayerOrange.addAnimation(animation, forKey: "second-half-Orange")
    }
    
    func setUpAnimationYellow() {
        let emitterLayerYellow = ParticleManager.getHomeBackgroundParticles("FireSparkYellow", longtitude: CGFloat(M_PI * 0.9))
        emitterView.layer.addSublayer(emitterLayerYellow)
        var animation = CABasicAnimation(keyPath: "emitterPosition")
        animation.fromValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionCenter)
        animation.toValue = NSValue(CGPoint: HomeViewDefaults.emitterPositionEndYellow)
        animation.duration = CFTimeInterval(2)
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        emitterLayerYellow.addAnimation(animation, forKey: "second-half-Yellow")
    }
    
    @IBAction func playGame(sender: AnyObject?) {
        self.mm_drawerController()!.openDrawerSide(MMDrawerSide.Right,
                                                    animated: true, completion: nil)
    }
    
    
    @IBAction func openSettingMenu(sender: AnyObject) {
        self.mm_drawerController()!.openDrawerSide(MMDrawerSide.Left,
                                                    animated: true, completion: nil)
    }
    
    func playMusic() {
        self.backgroundMusicPlayer.prepareToPlay()
        self.backgroundMusicPlayer.volume = 0
        self.backgroundMusicPlayer.numberOfLoops = -1
        self.backgroundMusicPlayer.play()
        self.fadeInMusic()
    }
    
    func fadeOutMusic() {
        if self.backgroundMusicPlayer.volume > 0.05 {
            self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - 0.05
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeOutMusic()
            })
            
        } else {
            self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - 0.05
            self.backgroundMusicPlayer.pause()
        }
    }
    
    func fadeInMusic() {
        if self.backgroundMusicPlayer.volume < 1 {
            self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume + 0.05
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeInMusic()
            })
        }
    }
    
    func startPlayingMusic(notification: NSNotification) {
        self.playMusic()
    }
    
    func stopPlayingMusic(notification: NSNotification) {
        self.fadeOutMusic()
    }

}
