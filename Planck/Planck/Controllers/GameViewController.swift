//
//  GameViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GameViewController: XViewController {

    var gameLevel: GameLevel = GameLevel()
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
    
    private var deviceViews = [String: UIView]()
    
    class func getInstance(gameLevel: GameLevel) -> GameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Game
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as GameViewController
        viewController.gameLevel = gameLevel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGrid()
    }
    
    private func setUpGrid() {
        println(self.xNodes)
        
        for (key, node) in self.grid.instruments {
            self.addNode(node, strokeColor: UIColor.blackColor())
        }
    }
    
    private func addNode(node: GOOpticRep, strokeColor: UIColor) -> Bool{
//        self.clearRay()
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
        
        if !self.moveNode(node, from: self.view.center, offset: offset) {
            view.removeFromSuperview()
            self.grid.removeInstrumentForID(node.id)
            return false
        }
        
        return true
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
