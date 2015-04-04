//
//  LevelDesignerViewController.swift
//  Planck
//
//  Created by NULL on 04/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class LevelDesignerViewController: UIViewController {

    @IBOutlet var deviceSegment: UISegmentedControl?
    @IBOutlet var inputModeSegment: UISegmentedControl?
    
    struct Selectors {
        static let tapAction: Selector = "viewDidTapped:"
        static let panAction: Selector = "viewDidPanned:"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGestureRecognizers()
    }
    
    private func setUpGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selectors.tapAction)
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selectors.panAction)
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    
    //MARK - tap gesture handler
    func viewDidTapped(sender: UITapGestureRecognizer) {
        
    }
    
    //MARK - pan gesture handler
    func viewDidPanned(sender: UIPanGestureRecognizer) {
        
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
