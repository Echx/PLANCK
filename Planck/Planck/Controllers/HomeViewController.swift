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
    
    struct Selectors {
        static let stopMusic: Selector = "stopPlayingMusic:"
        static let startMusic: Selector = "startPlayingMusic:"
    }
    
    struct Volumn {
        static let min: Float = 0.05
        static let max: Float = 1
        static let fadeStep: Float = 0.05
    }
    
    class func getInstance() -> HomeViewController {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.StoryBoardID, bundle: nil)
        let identifier = StoryboardIdentifier.Home
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as HomeViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(self.emitterView, atIndex: 1)
        self.emitterView.alpha = 0
        
        self.playMusic()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selectors.stopMusic,
            name: HomeViewDefaults.stopPlayingKey,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selectors.startMusic,
            name: HomeViewDefaults.startPlayingKey,
            object: nil
        )
        
        let gamiCent = GamiCent.sharedInstance({
            (isAuthentified) -> Void in
            if isAuthentified {
                let player = GamiCent.getPlayer()
                
                dispatch_async(dispatch_get_main_queue(), {
                    GamiCent.reportAchievements(
                        percent: 100.0,
                        achievementID: XGameCenter.achi_newbie,
                        isShowBanner: true,
                        completion: nil)
                    GamiCent.reportScoreLeaderboard(
                        leaderboardID: XGameCenter.leaderboardID,
                        score: GameLevel.countTotalScore(),
                        completion: nil
                    )
                })
                
            }
        })
        
        GamiCent.delegate = self
    }


    
    @IBAction func playGame(sender: AnyObject?) {
        self.getDrawerController()!.openDrawerSide(MMDrawerSide.Right,
                                                    animated: true, completion: nil)
    }
    
    
    @IBAction func openSettingMenu(sender: AnyObject) {
        self.getDrawerController()!.openDrawerSide(MMDrawerSide.Left,
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
        if self.backgroundMusicPlayer.volume > Volumn.min {
            self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - Volumn.fadeStep
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Volumn.fadeStep) * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeOutMusic()
            })
            
        } else {
            self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - Volumn.fadeStep
            self.backgroundMusicPlayer.pause()
        }
    }
    
    func fadeInMusic() {
        if self.backgroundMusicPlayer.volume < Volumn.max {
            self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume + Volumn.fadeStep
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Volumn.fadeStep) * Double(NSEC_PER_SEC)))
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
