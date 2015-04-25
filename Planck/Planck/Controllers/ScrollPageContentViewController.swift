//
//  ScrollPageContentViewController.swift
//  Planck
//
//  Created by Jiang Sheng on 18/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// This is the scroll content view controller for the right drawer
class ScrollPageContentViewController: XViewController {
    /// its parent ScrollPage VC
    var parentScrollPageVC:ScrollPageViewController?
    
    /// To be overrided : reload view data
    func reload() {
        fatalError("reload must be overriden by subclasses")
    }
}
