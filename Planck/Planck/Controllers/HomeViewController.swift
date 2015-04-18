//
//  HomeViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class HomeViewController: XViewController {
    
    private let emitterLayer = ParticleManager.getHomeBackgroundParticles()
    
    class func getInstance() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Home
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as HomeViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.addSublayer(self.emitterLayer)
        self.emitterLayer.emitterPosition = HomeViewDefaults.emitterInitialPosition
        
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
    }
    
    @IBAction func closeDrawerMenu(sender: AnyObject) {
        self.mm_drawerController()!.closeDrawerAnimated(true, completion: nil)
    }
    
    @IBAction func playGame(sender: AnyObject) {
        self.mm_drawerController()!.toggleDrawerSide(MMDrawerSide.Right,
                                                    animated: true, completion: nil)
    }
    
    
    @IBAction func openSettingMenu(sender: AnyObject) {
        self.mm_drawerController()!.toggleDrawerSide(MMDrawerSide.Left,
                                                    animated: true, completion: nil)
    }

}
