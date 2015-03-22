//
//  GameScene.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, XEmitterDelegate, SKPhysicsContactDelegate {
    var topPanelButtons = [AGSpriteButton]()
    var bottomPanelButtons = [AGSpriteButton]()
    let totalNumberOfDevices = LevelDesignerDefaults.buttonNames.count
    var currentOpticalDeviceMode: String = LevelDesignerDefaults.buttonNames[0]
    var needAddItems = true
    var selectedNode: XNode?
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.setUpButtons(LevelDesignerDefaults.buttonNames, selector: LevelDesignerDefaults.selectorButtonClicked, isOnTop: false)
        self.setUpButtons(LevelDesignerDefaults.functionalButtonNames, selector: LevelDesignerDefaults.selectorFunctionalButtonClicked, isOnTop: true)
        self.setUpGestureRecognizer()
    }

    private func setUpGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.view?.addGestureRecognizer(panGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handleRotationGesture:")
        self.view?.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    private func selectNodeAtPosition(position: CGPoint) -> Bool{
        if let touchedNode = self.nodeAtPoint(position) as? XNode {
            if touchedNode != self.selectedNode {
                self.deselectCurrentNode()
                self.selectedNode = touchedNode
                
                let shakeAction = SKAction.sequence([
                        SKAction.rotateByAngle(self.radius(-4), duration: 0.1),
                        SKAction.rotateByAngle(self.radius(0), duration: 0.1),
                        SKAction.rotateByAngle(self.radius(4), duration: 0.1)
                    ])
                self.selectedNode?.runAction(SKAction.repeatActionForever(shakeAction), withKey: ActionKey.nodeActionShake)
            }
            return true
        }
        return false
    }
    
    private func deselectCurrentNode() {
        self.selectedNode?.removeActionForKey(ActionKey.nodeActionShake)
        self.selectedNode?.runAction(SKAction.rotateToAngle(0, duration: 0.1))
    }
    
    
    private func radius(degree: CGFloat) -> CGFloat {
        return  degree / 180.0  * CGFloat(M_PI)
    }
    
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        let position = sender.locationInView(sender.view);
        if sender.state == UIGestureRecognizerState.Began {
            self.selectNodeAtPosition(self.convertPointFromView(position))
        } else if sender.state == UIGestureRecognizerState.Changed {
            var translation = sender.translationInView(sender.view!)
            translation = CGPointMake(translation.x, -translation.y)
            self.panForTranslation(translation)
            sender.setTranslation(CGPointZero, inView: sender.view)
        } else if sender.state == UIGestureRecognizerState.Ended {
            self.updateOpticalPath()
        }

    }
    
    func handleRotationGesture(sender: UIRotationGestureRecognizer) {
        if let instrument = self.selectedNode as? XInsrtument {
            instrument.setDirection(sender.rotation)
        }
        
    }
    
    private func panForTranslation(translation: CGPoint) {
        if let selectedNode = self.selectedNode {
            let position = selectedNode.position
            self.selectedNode?.position = CGPointMake(position.x + translation.x, position.y + translation.y)
        }

    }
    
    private func setUpButtons(buttonNames: [String], selector: Selector, isOnTop: Bool) {
        let buttonWidth = (UIScreen.mainScreen().bounds.width - CGFloat(buttonNames.count + 1) * LevelDesignerDefaults.interButtonSpace)/CGFloat(buttonNames.count)
        
        for var i = 0; i < buttonNames.count; i++ {
            let button = AGSpriteButton(
                color: LevelDesignerDefaults.buttonBackgroundColor,
                andSize: CGSize(
                    width: buttonWidth,
                    height: LevelDesignerDefaults.buttonHeight
                )
            )
            
            let positionX = CGFloat(i + 1) * LevelDesignerDefaults.interButtonSpace + (CGFloat(i) + 0.5) * buttonWidth
            var positionY: CGFloat
            
            if isOnTop {
                positionY = UIScreen.mainScreen().bounds.height - (LevelDesignerDefaults.buttonHeight/2 + LevelDesignerDefaults.interButtonSpace)
                self.topPanelButtons.append(button)
            } else {
                positionY = LevelDesignerDefaults.buttonHeight/2 + LevelDesignerDefaults.interButtonSpace
                self.bottomPanelButtons.append(button)
            }
            
            button.position = CGPoint(x: positionX, y: positionY)
            button.setLabelWithText(buttonNames[i], andFont: nil, withColor: LevelDesignerDefaults.buttonLabelColor)
            button.name = buttonNames[i]
            button.addTarget(self, selector: selector, withObject: button, forControlEvent: AGButtonControlEvent.TouchUpInside)

            self.addChild(button)
        }
        self.updateButtonAppearance(selectedButton: self.bottomPanelButtons[0])
    }
    
    func functionalButtonDidClicked(sender: AGSpriteButton?) {
        self.needAddItems = !self.needAddItems
        sender?.alpha = self.needAddItems ? 1.0 : 0.5
    }
    
    func buttonDidClicked(sender: AGSpriteButton?) {
        if let selectedButtonName = sender?.name {
            self.currentOpticalDeviceMode = selectedButtonName;
            updateButtonAppearance(selectedButton: sender);
        }
    }
    
    private func updateButtonAppearance(#selectedButton: AGSpriteButton?) {
        for button in self.bottomPanelButtons {
            if button == selectedButton {
                button.alpha = 1;
            } else {
                button.alpha = 0.5;
            }
        }
    }
    
    private func updateOpticalPath() {
        self.enumerateChildNodesWithName(EmitterDefualts.nodeName) {
            node, stop in
            let emitter = node as? XEmitter
            emitter?.photon?.lightBeam.removeFromParent()
            emitter?.photon?.removeFromParent()
            if emitter?.canFire == true {
                emitter?.fire()
            }
        }
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if self.needAddItems {
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                let nodeExistAtCurrentDirection = self.selectNodeAtPosition(location)
                
                if nodeExistAtCurrentDirection &&
                    self.currentOpticalDeviceMode != LevelDesignerDefaults.buttonNameEraser {
                        
                        return
                }
                
                if location.y > LevelDesignerDefaults.buttonHeight + LevelDesignerDefaults.interButtonSpace * 2 {
                    switch self.currentOpticalDeviceMode {
                    case LevelDesignerDefaults.buttonNameFlatMirror:
                        let mirror = XFlatMirror(direction: CGVector(dx: 1, dy: -1))
                        mirror.position = location
                        self.addChild(mirror)
                        mirror.zPosition = 999
                        
                    case LevelDesignerDefaults.buttonNameEmitter:
                        let emitter = XEmitter(appearanceColor: XColor(index: random()%8), direction: CGVector(dx: 1, dy: 0))
                        emitter.position = location
                        emitter.name = EmitterDefualts.nodeName
                        self.addChild(emitter)
                        emitter.zPosition = 1000
                        emitter.delegate = self
                    
                    case LevelDesignerDefaults.buttonNameWall:
                        let wall = XWall(direction: CGVector(dx: -1, dy: 0))
                        wall.position = location
                        self.addChild(wall)
                        
                    case LevelDesignerDefaults.buttonNamePlanck:
                        let planck = XPlanck(mapping: [(XColor(index: 1), XNote.Null)])
                        planck.position = location
                        self.addChild(planck)
                        planck.zPosition = 998
                        
                    case LevelDesignerDefaults.buttonNameInterface:
                        let interface = XInterface(direction: CGVectorMake(1, -1), medium1: XMedium.Air, medium2: XMedium.Water)
                        interface.position = location
                        self.addChild(interface)
                        interface.zPosition = 997
                        
                    case LevelDesignerDefaults.buttonNameEraser:
                        let eraserFrame = CGRectMake(
                            location.x - LevelDesignerDefaults.eraserSize/2,
                            location.y - LevelDesignerDefaults.eraserSize/2,
                            LevelDesignerDefaults.eraserSize,
                            LevelDesignerDefaults.eraserSize);
                        for node in self.children {
                            if CGRectIntersectsRect(node.calculateAccumulatedFrame(), eraserFrame) {
                                if let xNode = node as? XEmitter {
                                    xNode.photon?.lightBeam.removeFromParent()
                                    xNode.photon?.removeFromParent()
                                    (node as XEmitter).canFire = false
                                }
                                
                                let x = node as? XEmitter
                                
                                if let xNode = node as? XNode {
                                    node.removeFromParent();
                                }
                            }
                        }
                        
                    default:
                        fatalError("optical device mode not recognized")
                        
                    }
                    self.updateOpticalPath()
                }
            }
        } else {
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                self.selectNodeAtPosition(location)
                break
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.enumerateChildNodesWithName(NodeName.xPhoton, usingBlock:  {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            var sprite = node as XPhoton
            CGPathAddLineToPoint(sprite.opticalPath, nil, sprite.position.x, sprite.position.y)
            sprite.lightBeam.path = sprite.opticalPath
            sprite.lightBeam.strokeColor = sprite.appearanceColor.displayColor
            if sprite.parent != nil {
                if sprite.position.x < 0 || sprite.position.x > 1024 {
//                    sprite.removeActionForKey(ActionKey.photonActionLinear)
//                    let direction = CGVector(dx: -sprite.direction.dx, dy: sprite.direction.dy)
//                    sprite.setDirection(direction)
//                    var position = sprite.position;
//                    if position.x < 0 {
//                        position.x = 0
//                    } else {
//                        position.x = 1024
//                    }
//                    sprite.position = position
//                    sprite.runAction(SKAction.repeatActionForever(sprite.getAction()), withKey: ActionKey.photonActionLinear)
                }
                
                if sprite.position.y < 0 || sprite.position.y > 768 {
//                    sprite.removeActionForKey(ActionKey.photonActionLinear)
//                    sprite.removeFromParent()
//                    let direction = CGVector(dx: sprite.direction.dx, dy: -sprite.direction.dy)
//                    sprite.setDirection(direction)
//                    var position = sprite.position;
//                    if position.y < 0 {
//                        position.y = 0
//                    } else {
//                        position.y = 768
//                    }
//                    sprite.position = position
//                    sprite.runAction(SKAction.repeatActionForever(sprite.getAction()), withKey: ActionKey.photonActionLinear)
                }
            }
        })
    }
    
    
    // MARK - SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        var contactableNode: XContactable!
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.flatMirror != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.photon != 0)) {
                contactableNode = firstBody.node as XFlatMirror
        }
        
        // receptor and photon contact
        if ((firstBody.categoryBitMask & PhysicsCategory.planck != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.photon != 0)) {
                contactableNode = firstBody.node as XPlanck
        }
        
        // wall and photon contact
        if ((firstBody.categoryBitMask & PhysicsCategory.wall != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.photon != 0)) {
                contactableNode = firstBody.node as XWall
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.interface != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.photon != 0)) {
                contactableNode = firstBody.node as XInterface
        }
        
        if let photon = secondBody.node as? XPhoton {
            contactableNode.contactWithPhoton(photon)
        }
    }
    
    // MARK - XEmitterDelegate
    func emitterDidGenerateNewPhoton(emitter: XEmitter, photon: XPhoton, andAction action: SKAction) {
        photon.runAction(action, withKey: ActionKey.photonActionLinear)
        self.insertChild(photon, atIndex: 1)
        self.insertChild(photon.lightBeam, atIndex: 1)
    }
}
