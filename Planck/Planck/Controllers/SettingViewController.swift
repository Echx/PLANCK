//
//  SettingViewController.swift
//  Planck
//
//  Created by NULL on 07/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class SettingViewController: XViewController {
    
    class func getInstance() -> SettingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Setting
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as SettingViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
