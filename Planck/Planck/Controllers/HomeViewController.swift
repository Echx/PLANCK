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
