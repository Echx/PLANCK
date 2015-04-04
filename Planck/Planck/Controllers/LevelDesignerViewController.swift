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
    
    //store the layer we draw the various optic devices
    //key is the id of the instrument
    var deviceLayers = [String: CAShapeLayer]()
    
    let grid: GOGrid
    let identifierLength = 20;
    required init(coder aDecoder: NSCoder) {
        self.grid = GOGrid(width: 128, height: 96, andUnitLength: 8)
        super.init(coder: aDecoder)
    }
    
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
    
    private func addInstrument(instrument: GOOpticRep) {
        self.grid.addInstrument(instrument)
        let layer = CAShapeLayer()
        layer.strokeEnd = 1.0
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 2.0
        self.deviceLayers[instrument.id] = layer
        layer.path = self.grid.getInstrumentDisplayPathForID(instrument.id)?.CGPath
        self.view.layer.addSublayer(layer)
    }
    
    private func addRay(point: CGPoint) {
        let ray = GORay(startPoint: self.grid.getGridPointForDisplayPoint(point), direction: CGVector(dx: 1, dy: 0))
        let layer = CAShapeLayer()
        layer.strokeEnd = 1.0
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 2.0

        let path = self.grid.getRayPath(ray)
        layer.path = path.CGPath
        self.view.layer.addSublayer(layer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        pathAnimation.duration = 3.0;
        pathAnimation.repeatCount = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        layer.addAnimation(pathAnimation, forKey: "strokeEnd")
    }
    
    //MARK - tap gesture handler
    @IBAction func viewDidTapped(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(sender.view)
        let coordinate = self.grid.getGridCoordinateForPoint(location)
        
        switch(self.deviceSegment.selectedSegmentIndex) {
        case DeviceSegmentIndex.emitter:
            self.addRay(location)
            
        case DeviceSegmentIndex.flatMirror:
            let mirror = GOFlatMirrorRep(center: coordinate, thickness: 2, length: 8, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addInstrument(mirror)
            
        case DeviceSegmentIndex.flatLens:
            let flatLens = GOFlatLensRep(center: coordinate, thickness: 2, length: 8, direction: CGVectorMake(0, 1), refractionIndex: 1.5, id: String.generateRandomString(self.identifierLength))
            self.addInstrument(flatLens)
            
        case DeviceSegmentIndex.flatWall:
            let wall = GOFlatWallRep(center: coordinate, thickness: 2, length: 8, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addInstrument(wall)
            
        case DeviceSegmentIndex.concaveLens:
            let concaveLens = GOConcaveLensRep(center: coordinate, direction: CGVectorMake(0, 1), thicknessCenter: 1, thicknessEdge: 3, curvatureRadius: 10, id: String.generateRandomString(self.identifierLength), refractionIndex: 1.5)
            self.addInstrument(concaveLens)
            
        case DeviceSegmentIndex.convexLens:
            let convexLens = GOConvexLensRep(center: coordinate, direction: CGVectorMake(0, 1), thickness: 2, curvatureRadius: 10, id: String.generateRandomString(self.identifierLength), refractionIndex: 1.5)
            self.addInstrument(convexLens)
            
        case DeviceSegmentIndex.planck:
            let planck = GOFlatWallRep(center: coordinate, thickness: 6, length: 6, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addInstrument(planck)
            
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
