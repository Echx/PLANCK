//
//  LevelDesignerViewController.swift
//  Planck
//
//  Created by NULL on 04/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import AVFoundation

class LevelDesignerViewController: UIViewController {

    @IBOutlet var deviceSegment: UISegmentedControl!
    @IBOutlet var inputPanel: UIView!
    
    //store the views we draw the various optic devices
    //key is the id of the instrument
    private var deviceViews = [String: UIView]()
    private var rayLayers = [CAShapeLayer]()
    private var selectedNode: GOOpticRep?
    private var audioPlayer: AVAudioPlayer!
    private var grid: GOGrid
    
    private let identifierLength = 20
    private let gridWidth = 64
    private let gridHeight = 48
    private let gridUnitLength: CGFloat = 16
    
    
    struct Selectors {
        static let segmentValueDidChangeAction: Selector = "segmentValueDidChange:"
    }
    
    struct DeviceColor {
        static let mirror = UIColor.whiteColor()
        static let lens = UIColor(red: 190/255.0, green: 1, blue: 1, alpha: 1)
        static let wall = UIColor.blackColor()
        static let planck = UIColor.yellowColor()
        static let emitter = UIColor.greenColor()
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
    
    required init(coder aDecoder: NSCoder) {
        self.grid = GOGrid(width: self.gridWidth, height: self.gridHeight, andUnitLength: self.gridUnitLength)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputPanel.alpha = 0;
        self.inputPanel.userInteractionEnabled = false
        self.inputPanel.layer.cornerRadius = 20
    }
    
    //MARK - tap gesture handler
    @IBAction func viewDidTapped(sender: UITapGestureRecognizer) {
        if sender.numberOfTapsRequired == 1 {
            if sender.numberOfTouchesRequired == 2 {
                self.toggleInputPanel()
                return
            }
            
            if self.selectedNode != nil {
                self.deselectNode()
            } else {
                let location = sender.locationInView(sender.view)
                self.deselectNode()
                self.selectNode(self.grid.getInstrumentAtPoint(location))
            }
            return
        }

        
        let location = sender.locationInView(sender.view)
        let coordinate = self.grid.getGridCoordinateForPoint(location)
        
        switch(self.deviceSegment.selectedSegmentIndex) {
        case DeviceSegmentIndex.emitter:
            let emitter = GOEmitterRep(center: coordinate, thickness: 2, length: 2, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addNode(emitter, strokeColor: DeviceColor.emitter)
            
        case DeviceSegmentIndex.flatMirror:
            let mirror = GOFlatMirrorRep(center: coordinate, thickness: 2, length: 8, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addNode(mirror, strokeColor: DeviceColor.mirror)
            
        case DeviceSegmentIndex.flatLens:
            let flatLens = GOFlatLensRep(center: coordinate, thickness: 2, length: 8, direction: CGVectorMake(0, 1), refractionIndex: 1.5, id: String.generateRandomString(self.identifierLength))
            self.addNode(flatLens, strokeColor: DeviceColor.lens)
            
        case DeviceSegmentIndex.flatWall:
            let wall = GOFlatWallRep(center: coordinate, thickness: 2, length: 8, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addNode(wall, strokeColor: DeviceColor.wall)
            
        case DeviceSegmentIndex.concaveLens:
            let concaveLens = GOConcaveLensRep(center: coordinate, direction: CGVectorMake(0, 1), thicknessCenter: 1, thicknessEdge: 3, curvatureRadius: 10, id: String.generateRandomString(self.identifierLength), refractionIndex: 1.5)
            self.addNode(concaveLens, strokeColor: DeviceColor.lens)
            
        case DeviceSegmentIndex.convexLens:
            let convexLens = GOConvexLensRep(center: coordinate, direction: CGVectorMake(0, 1), thickness: 2, curvatureRadius: 10, id: String.generateRandomString(self.identifierLength), refractionIndex: 1.5)
            self.addNode(convexLens, strokeColor: DeviceColor.lens)
            
        case DeviceSegmentIndex.planck:
            let planck = GOFlatWallRep(center: coordinate, thickness: 6, length: 6, direction: CGVectorMake(0, 1), id: String.generateRandomString(self.identifierLength))
            self.addNode(planck, strokeColor: DeviceColor.planck)
            
        default:
            fatalError("SegmentNotRecognized")
        }
        self.shootRay()
    }
    
    //MARK - pan gesture handler
    private var firstLocation: CGPoint?
    private var lastLocation: CGPoint?
    private var firstViewCenter: CGPoint?
    private var firstViewTransform: CATransform3D?
    private var touchedNode: GOOpticRep?
    @IBAction func viewDidPanned(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(self.view)
        
        if let node = self.selectedNode {
            let view = self.deviceViews[node.id]!
            if sender.state == UIGestureRecognizerState.Began {
                firstLocation = location
                lastLocation = location
                firstViewTransform = view.layer.transform
            } else {
                let startVector = CGVectorMake(firstLocation!.x - self.grid.getCenterForGridCell(node.center).x,
                                               firstLocation!.y - self.grid.getCenterForGridCell(node.center).y)
                let currentVector = CGVectorMake(location.x - self.grid.getCenterForGridCell(node.center).x,
                                                 location.y - self.grid.getCenterForGridCell(node.center).y)
                var angle = CGVector.angleFrom(startVector, to: currentVector)
                if sender.state == UIGestureRecognizerState.Ended {
                    let nodeAngle = node.direction.angleFromXPlus
                    let effectAngle = angle + nodeAngle
                    let count = round(effectAngle / self.grid.unitDegree)
                    let finalAngle = self.grid.unitDegree * count
                    angle = finalAngle - nodeAngle
                    node.setDirection(CGVector.vectorFromXPlusRadius(finalAngle))
                }
                var layerTransform = CATransform3DRotate(firstViewTransform!, angle, 0, 0, 1)
                view.layer.transform = layerTransform
            }
        } else {
            if sender.state == UIGestureRecognizerState.Began || touchedNode == nil {
                firstLocation = location
                lastLocation = location
                touchedNode = self.grid.getInstrumentAtPoint(location)
                if let node = touchedNode {
                    firstViewCenter = self.deviceViews[node.id]!.center
                    self.clearRay()
                }
            }
            
            if let node = touchedNode {
                let view = self.deviceViews[node.id]!
                view.center = CGPointMake(view.center.x + location.x - lastLocation!.x, view.center.y + location.y - lastLocation!.y)
                lastLocation = location
                if sender.state == UIGestureRecognizerState.Ended {
                    
                    let offset = CGPointMake(location.x - firstLocation!.x, location.y - firstLocation!.y)
                    
                    self.moveNode(node, from: firstViewCenter!, offset: offset)
                    
                    lastLocation = nil
                    firstLocation = nil
                    firstViewCenter = nil
                }
            }

        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            self.shootRay()
        }
    }
    
    
    //MARK - long press gesture handler
    @IBAction func viewDidLongPressed(sender: UILongPressGestureRecognizer) {
        let location = sender.locationInView(sender.view)
        if let node = self.grid.getInstrumentAtPoint(location) {
            self.removeNode(node)
        }
    }
    
    //MARK - bar button handler
    @IBAction func clearButtonDidClicked(sender: UIBarButtonItem) {
        self.grid.clearInstruments()
        for (id, view) in self.deviceViews {
            view.removeFromSuperview()
        }
        
        self.clearRay()
    }
    
    
    
//------------------------------------------------------------------------------
//    Private Methods
//------------------------------------------------------------------------------
    
    private func toggleInputPanel() {
        if self.inputPanel.userInteractionEnabled {
            self.inputPanel.userInteractionEnabled = false
            self.inputPanel.alpha = 0
        } else {
            self.inputPanel.userInteractionEnabled = true
            self.inputPanel.alpha = 0.9
        }
    }
    
    private func selectNode(optionalNode: GOOpticRep?) {
        if let node = optionalNode {
            self.selectedNode = node
            if let view = self.deviceViews[node.id] {
                view.alpha = 0.5
            }
        } else {
            self.deselectNode()
        }
    }
    
    private func deselectNode() {
        if let node = self.selectedNode {
            if let view = self.deviceViews[node.id] {
                view.alpha = 1
            }
        }
        self.selectedNode = nil
    }
    
    private func addNode(node: GOOpticRep, strokeColor: UIColor) {
        self.clearRay()
        var coordinateBackup = node.center
        node.setCenter(GOCoordinate(x: self.grid.width/2, y: self.grid.height/2))
        
        self.grid.addInstrument(node)
        let layer = CAShapeLayer()
        layer.strokeEnd = 1.0
        layer.strokeColor = strokeColor.CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 2.0
        layer.path = self.grid.getInstrumentDisplayPathForID(node.id)?.CGPath
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        view.backgroundColor = UIColor.clearColor()
        view.layer.addSublayer(layer)
        self.deviceViews[node.id] = view
        self.view.insertSubview(view, atIndex: 0)
        
        var offsetX = CGFloat(coordinateBackup.x - node.center.x) * self.grid.unitLength
        var offsetY = CGFloat(coordinateBackup.y - node.center.y) * self.grid.unitLength
        var offset = CGPointMake(offsetX, offsetY)
        
        self.moveNode(node, from: self.view.center, offset: offset)
    }

    
    private func moveNode(node: GOOpticRep, from: CGPoint,offset: CGPoint) {
        let offsetX = offset.x
        let offsetY = offset.y
        
        let originalDisplayPoint = self.grid.getCenterForGridCell(node.center)
        let effectDisplayPoint = CGPointMake(originalDisplayPoint.x + offsetX, originalDisplayPoint.y + offsetY)
        
        node.setCenter(self.grid.getGridCoordinateForPoint(effectDisplayPoint))
        
        let view = self.deviceViews[node.id]!
        let finalDisplayPoint = self.grid.getCenterForGridCell(node.center)
        let finalX = finalDisplayPoint.x - originalDisplayPoint.x + from.x
        let finalY = finalDisplayPoint.y - originalDisplayPoint.y + from.y
        
        view.center = CGPointMake(finalX, finalY)
    }

    private func removeNode(node: GOOpticRep) {
        self.deviceViews[node.id]?.removeFromSuperview()
        self.deviceViews[node.id] = nil
        self.grid.removeInstrumentForID(node.id)
        self.shootRay()
    }
    
    private func addRay(point: CGPoint) {
        let ray = GORay(startPoint: self.grid.getGridPointForDisplayPoint(point), direction: CGVector(dx: 1, dy: 0))
        let layer = CAShapeLayer()
        layer.strokeEnd = 1.0
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 2.0
        
        self.rayLayers.append(layer)
        
        let goPath = self.grid.getRayPath(ray)
        let path = goPath.bezierPath
        let points = goPath.criticalPoints
        let distance = goPath.pathLength
        self.processPoints(points)
        layer.path = path.CGPath
        self.view.layer.addSublayer(layer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        pathAnimation.duration = CFTimeInterval(distance / Constant.lightSpeedBase);
        pathAnimation.repeatCount = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        layer.addAnimation(pathAnimation, forKey: "strokeEnd")
    }
    
    private func shootRay() {
        self.clearRay()
        for (name, item) in self.grid.instruments {
            if item.type == DeviceType.Emitter {
                let coordinate = (item as GOEmitterRep).center
                let shootingCoordinate = GOCoordinate(x: coordinate.x + 1, y: coordinate.y)
                let shootingPoint = self.grid.getPointForGridCoordinate(shootingCoordinate)
                self.addRay(shootingPoint)
            }
            
        }
    }
    
    private func clearRay() {
        for layer in self.rayLayers {
            layer.removeFromSuperlayer()
        }
    }
    
    private func getColorForNode(node: GOOpticRep) -> UIColor {
        switch node.type {
        case .Emitter:
            return DeviceColor.emitter
        case .Lens:
            return DeviceColor.lens
        case .Mirror:
            return DeviceColor.mirror
        case .Wall:
            return DeviceColor.planck
            
        default:
            return UIColor.whiteColor()
        }
    }
    
    private func processPoints(points: [CGPoint]) {
        if points.count > 2 {
            var bounceSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cymbal", ofType: "m4a")!)
            var prevPoint = points[0]
            var distance: CGFloat = 0
            for i in 1...points.count - 1 {
                distance += points[i].getDistanceToPoint(prevPoint)
                prevPoint = points[i]
                if let device = self.grid.getInstrumentAtGridPoint(points[i]) {
                    switch device.type {
                    case DeviceType.Mirror :
                        self.audioPlayer = AVAudioPlayer(contentsOfURL: bounceSound, error: nil)
                        self.audioPlayer.prepareToPlay()
                        let wait = NSTimeInterval(distance / Constant.lightSpeedBase + Constant.audioDelay)
                        self.audioPlayer.playAtTime(wait + self.audioPlayer.deviceCurrentTime)

                    default :
                        1
                    }
                }
            }
        }
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
