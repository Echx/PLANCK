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
                    GamiCent.reportScoreLeaderboard(leaderboardID: XGameCenter.leaderboardID, score: GameStats.getTotalScore(), completion: { success in
                        println(success)
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
    
    @IBAction func viewDidTapped(sender: UITapGestureRecognizer) {
        var touchPoint = sender.locationInView(self.view)
        println(touchPoint)
        self.emitterLayer.emitterPosition = touchPoint
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
