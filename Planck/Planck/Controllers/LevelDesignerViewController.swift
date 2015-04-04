//
//  LevelDesignerViewController.swift
//  Planck
//
//  Created by NULL on 04/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class LevelDesignerViewController: UIViewController {

    @IBOutlet var deviceSegment: UISegmentedControl!

    
    struct Selectors {
        static let segmentValueDidChangeAction: Selector = "segmentValueDidChange:"
    }
    
    struct DeviceSegmentIndex {
        static let emitter = 0;
        static let flatMirror = 1;
        static let flatLens = 2;
        static let flatWall = 3;
        static let concaveLens = 4;
        static let convexLens = 5;
        static let planck = 6;
    }
    
    struct InputModeSegmentIndex {
        static let add = 0;
        static let edit = 1;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - tap gesture handler
    @IBAction func viewDidTapped(sender: UITapGestureRecognizer) {
        switch(self.deviceSegment.selectedSegmentIndex) {
        case DeviceSegmentIndex.emitter:
            println("tap detected: emitter");
        case DeviceSegmentIndex.flatMirror:
            println("tap detected: flat mirror");
        case DeviceSegmentIndex.flatLens:
            println("tap detected: flat lens");
        case DeviceSegmentIndex.flatWall:
            println("tap detected: flat wall");
        case DeviceSegmentIndex.concaveLens:
            println("tap detected: concave lens");
        case DeviceSegmentIndex.convexLens:
            println("tap detected: convex lens");
        case DeviceSegmentIndex.planck:
            println("tap detected: planck");
        default:
            fatalError("SegmentNotRecognized")
        }
    }
    
    //MARK - pan gesture handler
    @IBAction func viewDidPanned(sender: UIPanGestureRecognizer) {
        println("pan detected");
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
