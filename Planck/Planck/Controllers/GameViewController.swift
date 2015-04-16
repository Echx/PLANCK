//
//  GameViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GameViewController: XViewController {

    @IBOutlet var shootSwitch: UISwitch!
    
    var gameLevel: GameLevel = GameLevel()
    // keep a copy of original level
    private var originalLevel: GameLevel = GameLevel()
    private var rayLayers = [String: [CAShapeLayer]]()
    private var rays = [String: [(CGPoint, GOSegment?)]]()
    private var audioPlayerList = [AVAudioPlayer]()
    private var music = XMusic()
    private var pathDistances = [String: CGFloat]()
    private var visitedPlanckList = [XNode]()
    private var emitterLayers = [String: [CAEmitterLayer]]()
    private var deviceViews = [String: UIView]()
    private var transitionMask = LevelTransitionMaskView()
    private var pauseMask = PauseMaskView()
    private var musicMask = TargetMusicMaskView()
    private var numberOfFinishedRay = 0
    private var audioPlayer: AVAudioPlayer?
    
    private var isVirgin: Bool?
    private var shouldShowNextLevel: Bool = false
    private var queue = dispatch_queue_create("CHECKING_SERIAL_QUEUE", DISPATCH_QUEUE_SERIAL)
    
    private var grid: GOGrid {
        get {
            return gameLevel.grid
        }
    }
    private var xNodes : [String: XNode] {
        get {
            return gameLevel.xNodes
        }
    }
    
    /// a boolean value indicate if the game play is in preview mode or not
    private var isPreview:Bool = false
    
    class func getInstance(gameLevel: GameLevel, isPreview:Bool) -> GameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Game
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as GameViewController
        viewController.gameLevel = gameLevel
        viewController.originalLevel = gameLevel.deepCopy()
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.isPreview = isPreview
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mainbackground")!)
        self.pauseMask.delegate = self
        self.transitionMask.delegate = self
        self.musicMask.delegate = self
        self.showTargetMusicMask()
        
        if self.isPreview {
            self.transitionMask.shouldShowButtons = false
        }
    }
    
    private func reloadLevel(gameLevel: GameLevel) {
        self.isVirgin = nil
        self.shootSwitch.setOn(false, animated: true)
        self.clear()
        self.gameLevel = gameLevel
        self.originalLevel = gameLevel.deepCopy()

        self.setUpGrid()
    }
    
    private func clear() {
        self.clearRay()
        self.clearDevice()
    }
    
    private func clearDevice() {
        for (key, view) in self.deviceViews {
            view.removeFromSuperview()
        }
        self.deviceViews = [String: UIView]()
    }
    
    @IBAction func switchValueDidChange(sender: UISwitch) {
        if sender.on {
            if self.isVirgin == nil {
                self.isVirgin = true
            } else if self.isVirgin! {
                self.isVirgin = false
            }
            self.shootRay()
        } else {
            self.clearRay()
        }
    }
    
    @IBAction func viewDidTapped(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(sender.view)
        if let node = self.grid.getInstrumentAtPoint(location) {
            OscillationManager.oscillateView(
                self.deviceViews[node.id]!,
                direction: CGVectorMake(1, 0))
            if let sound = self.xNodes[node.id]?.getSound() {
                if let wall = node as? GOFlatWallRep {
                } else {
                    audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: nil)
                    audioPlayer!.prepareToPlay()
                    audioPlayer!.play()
                }
            }
            
            if self.isNodeFixed(node) {
                println("node is fixed")
            } else {
                self.shootSwitch.setOn(false, animated: true)
                self.clearRay()
                updateDirection(node)
            }
        }
    }
    
    private var firstLocation: CGPoint?
    private var lastLocation: CGPoint?
    private var firstViewCenter: CGPoint?
    private var touchedNode: GOOpticRep?
    
    @IBAction func pauseButtonDidClicked(sender: UIButton) {
        self.view.addSubview(self.pauseMask)
        self.pauseMask.show()
    }
    
    @IBAction func viewDidPanned(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(self.view)
        if sender.state == UIGestureRecognizerState.Began || touchedNode == nil {
            firstLocation = location
            lastLocation = location
            touchedNode = self.grid.getInstrumentAtPoint(location)
            if let node = touchedNode {
                if !self.isNodeFixed(node) {
                    firstViewCenter = self.deviceViews[node.id]!.center
                    self.shootSwitch.setOn(false, animated: true)
                    self.clearRay()
                } else {
                    touchedNode = nil
                }
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
                touchedNode = nil
            }
        }
    }
    
    private func updateDirection(node: GOOpticRep) {
        let newDirectionIndex = Int(round(node.direction.angleFromXPlus / self.grid.unitDegree)) + 1
        let originalDirection = node.direction
        let effectDirection = CGVector.vectorFromXPlusRadius(CGFloat(newDirectionIndex) * self.grid.unitDegree)
        self.updateDirection(node, startVector: originalDirection, currentVector: effectDirection)
    }
    
    private func updateDirection(node: GOOpticRep, startVector: CGVector, currentVector: CGVector) {
        var angle = CGVector.angleFrom(startVector, to: currentVector)
        let nodeAngle = node.direction.angleFromXPlus
        let effectAngle = angle + nodeAngle
        let count = round(effectAngle / self.grid.unitDegree)
        let finalAngle = self.grid.unitDegree * count
        angle = finalAngle - nodeAngle
        node.setDirection(CGVector.vectorFromXPlusRadius(finalAngle))
        if let view = self.deviceViews[node.id] {
            var layerTransform = CATransform3DRotate(view.layer.transform, angle, 0, 0, 1)
            view.layer.transform = layerTransform
        }
    }
    
    
    private func isNodeFixed(node: GOOpticRep) -> Bool {
        if let xNode = self.xNodes[node.id] {
            return xNode.isFixed
        }
        fatalError("Inconsistency between xNodes and nodes")
    }
    
    var nodeCount = 0
    private func setUpGrid() {
        for (key, node) in self.grid.instruments {
            self.addNode(node, strokeColor: self.xNodes[node.id]!.strokeColor)
            nodeCount++;
        }
        
        nodeCount = 0
        self.grid.delegate = self
    }
    
    private func shootRay() {
        self.clearRay()
        for (name, item) in self.grid.instruments {
            if let item = item as? GOEmitterRep {
                self.addRay(item.getRay())
            }
        }
    }
    
    private func addRay(ray: GORay) {
        var newTag = String.generateRandomString(20)
        self.rays[newTag] = [(CGPoint, GOSegment?)]()
        self.rayLayers[newTag] = [CAShapeLayer]()
        self.grid.startCriticalPointsCalculationWithRay(ray, withTag: newTag)
    }
    
    private func clearRay() {
        self.grid.stopSubsequentCalculation()
        for (key, layers) in self.rayLayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        
        for (key, layers) in self.emitterLayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        
        self.audioPlayerList.removeAll(keepCapacity: false)
        self.rayLayers = [String: [CAShapeLayer]]()
        self.rays = [String: [(CGPoint, GOSegment?)]]()
        self.music.reset()
        self.pathDistances = [String: CGFloat]()
        self.visitedPlanckList = [XNode]()
        self.numberOfFinishedRay = 0
    }
    
    private func drawRay(tag: String, currentIndex: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            if self.rays.count == 0 {
                return
            }
            
            if currentIndex < self.rays[tag]?.count {
                let layer = CAShapeLayer()
                layer.strokeEnd = 1.0
                layer.strokeColor = UIColor(white: 1, alpha: 0.2).CGColor
                layer.fillColor = UIColor.clearColor().CGColor
                layer.lineWidth = 5.0
                
                self.rayLayers[tag]?.append(layer)
                
                var path = UIBezierPath()
                let rayPath = self.rays[tag]!
                let prevPoint = rayPath[currentIndex - 1]
                let currentPoint = rayPath[currentIndex]
                path.lineJoinStyle = kCGLineJoinBevel
                path.lineCapStyle = kCGLineCapRound
                path.moveToPoint(prevPoint.0)
                path.addLineToPoint(currentPoint.0)
                let distance = prevPoint.0.getDistanceToPoint(currentPoint.0)
                layer.path = path.CGPath
                layer.shadowOffset = CGSizeZero
                layer.shadowRadius = 2
                layer.shadowColor = UIColor.whiteColor().CGColor
                layer.shadowOpacity = 0.9
                
                self.view.layer.addSublayer(layer)
                
                let delay = distance / Constant.lightSpeedBase
                
                //emitter
//                let emitterLayer = ParticleManager.getParticleLayer()
//                if self.emitterLayers[tag] == nil {
//                    self.emitterLayers[tag] = [CAEmitterLayer]()
//                }
//                self.emitterLayers[tag]?.append(emitterLayer)
//                self.view.layer.addSublayer(emitterLayer)
//                emitterLayer.emitterPosition = prevPoint.0
//                var emitterPath = CGPathCreateCopy(path.CGPath)
//                //                CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
//                
//                var animation = CABasicAnimation(keyPath: "emitterPosition")
//                animation.fromValue = NSValue(CGPoint: prevPoint.0)
//                animation.toValue = NSValue(CGPoint: currentPoint.0)
//                animation.duration = CFTimeInterval(delay)
//                animation.repeatCount = 1.0
//                animation.removedOnCompletion = true
//                emitterLayer.addAnimation(animation, forKey: "test")
                
                //end of emitter
                
                let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
                pathAnimation.fromValue = 0.0
                pathAnimation.toValue = 1.0
                pathAnimation.duration = CFTimeInterval(delay)
                pathAnimation.repeatCount = 1.0
                pathAnimation.fillMode = kCAFillModeForwards
                pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                
                layer.addAnimation(pathAnimation, forKey: "strokeEnd")
                if currentIndex > 1 {
                    self.playNote(prevPoint.1, tag: tag)
                    OscillationManager.oscillateView(
                        self.deviceViews[prevPoint.1!.parent]!,
                        direction: CGVectorMake(
                            currentPoint.0.x - prevPoint.0.x,
                            currentPoint.0.y - prevPoint.0.y))
                }
                
                if self.pathDistances[tag] == nil {
                    self.pathDistances[tag] = CGFloat(0)
                }
                
                self.pathDistances[tag]! += distance
                let delayInNanoSeconds = 0.9 * delay * CGFloat(NSEC_PER_SEC);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayInNanoSeconds)), dispatch_get_main_queue()) {
                    self.drawRay(tag, currentIndex: currentIndex + 1)
                }
            } else {
                self.numberOfFinishedRay++
                
                if let rayPath = self.rays[tag] {
                    let prevPoint = rayPath[currentIndex - 1]
                    self.playNote(prevPoint.1, tag: tag)
                }
                
                if self.numberOfFinishedRay == self.rays.count {
                    dispatch_async(self.queue, {
                        if self.music.isSimilarTo(self.originalLevel.targetMusic) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * 0.5)), dispatch_get_main_queue()) {
                                if self.isVirgin! {
                                    self.showBadgeMask(3)
                                    if self.originalLevel.bestScore < 3 {
                                        self.originalLevel.bestScore = 3
                                    }
                                } else {
                                    self.showBadgeMask(2)
                                    if self.originalLevel.bestScore < 2 {
                                        self.originalLevel.bestScore = 2
                                    }
                                }
                            }
                            
                            self.shouldShowNextLevel = true
                        } else if self.music.numberOfPlanck == self.gameLevel.targetMusic.numberOfPlanck {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * 1.5)), dispatch_get_main_queue()) {
                                self.showBadgeMask(1)
                                if self.originalLevel.bestScore < 1 {
                                    self.originalLevel.bestScore = 1
                                }
                            }
                            
                            self.shouldShowNextLevel = true
                        } else {
                            self.shouldShowNextLevel = false
                        }
                    })
                }
            }
        }
    }
    
    private func showBadgeMask(numberOfBadge: Int) {
        self.view.addSubview(self.transitionMask)
        self.transitionMask.show(numberOfBadge)
    }
    
    private func showTargetMusicMask() {
        self.view.addSubview(self.musicMask)
        self.musicMask.show(self.gameLevel.targetMusic)
    }
    
    @IBAction func playMusic(sender: UIButton) {
        self.musicMask.show(self.gameLevel.targetMusic)
    }
    
    private func playNote(segment: GOSegment?, tag: String) {
        if let edge = segment {
            if let device = xNodes[edge.parent] {
                if !contains(self.visitedPlanckList, device) {
                    self.visitedPlanckList.append(device)
                    self.music.numberOfPlanck++
                }
                
                if let sound = device.getSound() {
                    let audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: nil)
                    self.audioPlayerList.append(audioPlayer)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    
                    let note = device.getNote()!
                    self.music.appendDistance(self.pathDistances[tag]!, forNote: note)
                }
            } else {
                fatalError("The node for the physics body not existed")
            }
        }
    }
    

    
    private func addNode(node: GOOpticRep, strokeColor: UIColor) -> Bool{
        var coordinateBackup = node.center
        node.setCenter(GOCoordinate(x: self.grid.width/2, y: self.grid.height/2))
        
        self.grid.addInstrument(node)
        
        if node.type == DeviceType.Emitter {
            let imageView = UIImageView(image: UIImage(named: "flashlight"))
            
            let view = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            view.backgroundColor = UIColor.clearColor()
            imageView.frame = CGRect(x: 0, y: 0, width: self.grid.unitLength * 4.5, height: self.grid.unitLength * 1.5)
            imageView.center = view.center
            
            let degree = node.direction.angleFromXPlus
            imageView.transform = CGAffineTransformMakeRotation(degree)
            
            view.addSubview(imageView)
            view.layer.zPosition = 100
            self.deviceViews[node.id] = view
            
            self.view.insertSubview(view, atIndex: 0)
            
            var offsetX = CGFloat(coordinateBackup.x - node.center.x) * self.grid.unitLength
            var offsetY = CGFloat(coordinateBackup.y - node.center.y) * self.grid.unitLength
            var offset = CGPointMake(offsetX, offsetY)
            
            if !self.moveNode(node, from: self.view.center, offset: offset) {
                view.removeFromSuperview()
                self.grid.removeInstrumentForID(node.id)
                return false
            }
            
            return true
        } else {
            let layer = CAShapeLayer()
            layer.strokeEnd = 1.0
            layer.fillColor = strokeColor.CGColor
            layer.lineWidth = 2
            if let xnode = self.xNodes[node.id] {
                if !xnode.isFixed {
                    layer.strokeColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
                } else {
                    layer.strokeColor = UIColor.clearColor().CGColor
                }
            } else {
                fatalError("no corresponding xnode")
            }
            layer.shadowRadius = 2
            layer.shadowColor = strokeColor.CGColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSizeZero
            layer.path = self.grid.getInstrumentDisplayPathForID(node.id)?.CGPath
            
            let view = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            view.backgroundColor = UIColor.clearColor()
            view.layer.addSublayer(layer)
            self.deviceViews[node.id] = view

            self.view.insertSubview(view, atIndex: 0)
            
            var offsetX = CGFloat(coordinateBackup.x - node.center.x) * self.grid.unitLength
            var offsetY = CGFloat(coordinateBackup.y - node.center.y) * self.grid.unitLength
            var offset = CGPointMake(offsetX, offsetY)
            
            if !self.moveNode(node, from: self.view.center, offset: offset) {
                view.removeFromSuperview()
                self.grid.removeInstrumentForID(node.id)
                return false
            }
            
            return true
        }
    }

    private func moveNode(node: GOOpticRep, from: CGPoint,offset: CGPoint) -> Bool{
        let offsetX = offset.x
        let offsetY = offset.y
        
        let originalDisplayPoint = self.grid.getCenterForGridCell(node.center)
        let effectDisplayPoint = CGPointMake(originalDisplayPoint.x + offsetX, originalDisplayPoint.y + offsetY)
        
        let centerBackup = node.center
        
        //check whether the node will overlap with other nodes with the new center
        node.setCenter(self.grid.getGridCoordinateForPoint(effectDisplayPoint))
        if self.grid.isInstrumentOverlappedWidthOthers(node) {
            //overlapped recover the center and view
            node.setCenter(centerBackup)
            //recover the view
            let view = self.deviceViews[node.id]!
            view.center = originalDisplayPoint
            return false
        } else{
            //not overlap, move the view to the new position
            let view = self.deviceViews[node.id]!
            let finalDisplayPoint = self.grid.getCenterForGridCell(node.center)
            let finalX = finalDisplayPoint.x - originalDisplayPoint.x + from.x
            let finalY = finalDisplayPoint.y - originalDisplayPoint.y + from.y
            
            view.center = CGPointMake(finalX, finalY)
            return true
        }
    }
    
    
    private func moveNode(node: GOOpticRep, to: GOCoordinate) -> Bool{
        let originalCenter = self.grid.getCenterForGridCell(node.center)
        let finalCenter = self.grid.getCenterForGridCell(to)
        let offsetX = finalCenter.x - originalCenter.x
        let offsetY = finalCenter.y - originalCenter.y
        let offset = CGPointMake(offsetX, offsetY)
        return self.moveNode(node, from: originalCenter, offset: offset)
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

extension GameViewController: GOGridDelegate {
    func grid(grid: GOGrid, didProduceNewCriticalPoint point: CGPoint, onEdge edge: GOSegment?, forRayWithTag tag: String) {
        if self.rays.count == 0 {
            // waiting for thread to complete
            return
        }
        
        self.rays[tag]?.append((point, edge))
        if self.rays[tag]?.count == 2 {
            // when there are 2 points, start drawing
            drawRay(tag, currentIndex: 1)
        }
    }
    
    func gridDidFinishCalculation(grid: GOGrid, forRayWithTag tag: String) {

    }
}

extension GameViewController: PauseMaskViewDelegate {
    func buttonDidClickedAtIndex(index: Int) {
        switch index {
        case 0:
            self.dismissViewController()
            
        case 2:
            self.pauseMask.hide()
            
        default:
            self.reloadLevel(self.originalLevel)
            self.pauseMask.hide()
        }
    }
}

extension GameViewController: LevelTransitionMaskViewDelegate {
    func viewDidDismiss(view: LevelTransitionMaskView, withButtonClickedAtIndex index: Int) {
        if index == 2 {
            if self.shouldShowNextLevel {
                // save current game if it is not preview mode
                if !isPreview {
                    println("saving!")
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        StorageManager.defaultManager.saveCurrentLevel(self.originalLevel)
                    })
                }
                
                if let nextLevel = GameLevel.loadGameWithIndex(self.gameLevel.index + 1) {
                    // in preview mode, can neve reach here
                    // unlock next level and save it
                    nextLevel.isUnlock = true
                    println("saving next!")
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        StorageManager.defaultManager.saveCurrentLevel(nextLevel)
                    })
                    
                    println("nextLevel: \(self.gameLevel.index + 1)")
                    self.reloadLevel(nextLevel)
                    self.view.addSubview(self.musicMask)
                    self.musicMask.show(self.gameLevel.targetMusic)
                } else {
                    println("nextLevel: \(self.gameLevel.index + 1)")
                    // have finished all current game
                    self.dismissViewController()
                }
            }
        } else {
            self.buttonDidClickedAtIndex(index)
        }
        
    }
}

extension GameViewController: TargetMusicMaskViewDelegate {
    func didFinishPlaying() {
        self.musicMask.hide()
    }
    
    func musicMaskViewDidDismiss(view: TargetMusicMaskView) {
        self.setUpGrid()
    }
}
