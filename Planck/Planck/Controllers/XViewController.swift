//
//  XViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension XViewController {
    func mm_drawerController() -> MMDrawerController? {
        var parentViewController = self.parentViewController
        while (parentViewController != nil) {
            if parentViewController!.isKindOfClass(MMDrawerController) {
                return parentViewController as? MMDrawerController
            }
            parentViewController = parentViewController!.parentViewController
        }
        return nil
    }
}
