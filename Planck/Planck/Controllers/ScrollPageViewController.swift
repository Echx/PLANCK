//
//  ScrollPageViewController.swift
//  Planck
//
//  Created by Jiang Sheng on 18/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// This is the scroll view controller for the right drawer
class ScrollPageViewController: XViewController, UIScrollViewDelegate {
    class func getInstance(controllers:[ScrollPageContentViewController])
        -> ScrollPageViewController {
        let storyboard = UIStoryboard(
            name: StoryboardIdentifier.StoryBoardID, bundle: nil)
        let identifier = StoryboardIdentifier.ScrollPage
        let viewController = storyboard.instantiateViewControllerWithIdentifier(
            identifier) as ScrollPageViewController
        viewController.controllers = controllers
        
        return viewController
    }

    @IBOutlet weak var myScrollView: UIScrollView!
    
    // store the VC to presented
    private var controllers:[ScrollPageContentViewController] = [ScrollPageContentViewController]()
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for vc in controllers {
            vc.parentScrollPageVC = self
        }
        
        // set up scroll view
        self.myScrollView.pagingEnabled = true
        let numOfPage = CGFloat(controllers.count)
        let contentWidth = CGRectGetWidth(self.myScrollView.frame) * numOfPage
        let contentHeight = CGRectGetHeight(self.myScrollView.frame)
        self.myScrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        self.myScrollView.scrollsToTop = false
        
        // load init two pages
        for var i = 0; i < controllers.count; i++ {
            loadScrollViewWithPage(i)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Refresh the level select view when it appears
        self.controllers[currentPage].reload()
    }
    
    //load different pages into scroll view
    func loadScrollViewWithPage(page: Int) {
        if page >= self.controllers.count {
            return
        }
        
        let controller = self.controllers[page]
        if controller.view.superview == nil {
            var frame = self.myScrollView.frame
            frame.origin.x = CGRectGetWidth(frame) * CGFloat(page)
            frame.origin.y = 0
            controller.view.frame = frame
            self.myScrollView.addSubview(controller.view)
        }
    }
    
    // - MARKS: ScrollView Delegate method
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = CGRectGetWidth(self.myScrollView.frame)
        let page = Int(floor(self.myScrollView.contentOffset.x / pageWidth))
        
        self.currentPage = page
        
        // reload the level select after we have scrolled to it.
        self.controllers[currentPage].reload()
    }
}
