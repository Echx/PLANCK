//
//  HomeViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import AVFoundation


//This class controls the home view which will be presented when player first get into the game
class HomeViewController: XViewController {
    private let backgroundMusicPlayer = AVAudioPlayer(
        contentsOfURL: SoundFiles.backgroundMusic, error: nil
    )
    
    struct Selectors {
        static let stopMusic: Selector = "stopPlayingMusic:"
        static let startMusic: Selector = "startPlayingMusic:"
    }
    
    struct Volumn {
        static let min: Float = 0.05
        static let max: Float = 1
        static let fadeStep: Float = 0.05
        static let initial: Float = 0
    }
    
    class func getInstance() -> HomeViewController {
        let storyboard = UIStoryboard(
            name: StoryboardIdentifier.StoryBoardID, bundle: nil)
        let identifier = StoryboardIdentifier.Home
        let viewController = storyboard.instantiateViewControllerWithIdentifier(
            identifier) as HomeViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        percent: 100.0, //hundred percentage
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


    //open right(game) menu
    @IBAction func playGame(sender: AnyObject?) {
        self.getDrawerController()!.openDrawerSide(
            MMDrawerSide.Right, animated: true, completion: nil)
    }
    
    //open left(setting) menu
    @IBAction func openSettingMenu(sender: AnyObject) {
        self.getDrawerController()!.openDrawerSide(
            MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    //play background music
    func playMusic() {
        self.backgroundMusicPlayer.prepareToPlay()
        self.backgroundMusicPlayer.volume = Volumn.initial
        //-1 means loop forever
        self.backgroundMusicPlayer.numberOfLoops = -1
        self.backgroundMusicPlayer.play()
        self.fadeInMusic()
    }
    
    //fade out background music
    func fadeOutMusic() {
        if self.backgroundMusicPlayer.volume > Volumn.min {
            self.backgroundMusicPlayer.volume =
                self.backgroundMusicPlayer.volume - Volumn.fadeStep
            
            var dispatchTime: dispatch_time_t =
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(Double(Volumn.fadeStep) * Double(NSEC_PER_SEC))
                )
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeOutMusic()
            })
            
        } else {
            self.backgroundMusicPlayer.volume =
                self.backgroundMusicPlayer.volume - Volumn.fadeStep
            self.backgroundMusicPlayer.pause()
        }
    }
    
    //fade in background music
    func fadeInMusic() {
        if self.backgroundMusicPlayer.volume < Volumn.max {
            self.backgroundMusicPlayer.volume =
                self.backgroundMusicPlayer.volume + Volumn.fadeStep
            
            var dispatchTime: dispatch_time_t =
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(Double(Volumn.fadeStep) * Double(NSEC_PER_SEC))
                )
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeInMusic()
            })
        }
    }
    
    
    //MARK: - Notification Handlers
    func startPlayingMusic(notification: NSNotification) {
        self.playMusic()
    }
    
    func stopPlayingMusic(notification: NSNotification) {
        self.fadeOutMusic()
    }

}
