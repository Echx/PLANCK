//
//  GameScene.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, XEmitterDelegate, SKPhysicsContactDelegate {
    var panelButtons = [AGSpriteButton]()
    let totalNumberOfDevices = LevelDesignerDefaults.buttonNames.count
    var currentOpticalDeviceMode: String = LevelDesignerDefaults.buttonNames[0]
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        self.setUpButtonPanel()
        self.updateButtonAppearance(selectedButton: self.panelButtons[0])
    }
    
    func setUpButtonPanel() {
        let buttonWidth = (UIScreen.mainScreen().bounds.width - CGFloat(self.totalNumberOfDevices + 1) * LevelDesignerDefaults.interButtonSpace)/CGFloat(self.totalNumberOfDevices)
        
        for var i = 0; i < self.totalNumberOfDevices; i++ {
            let button = AGSpriteButton(
                color: LevelDesignerDefaults.buttonBackgroundColor,
                andSize: CGSize(
                    width: buttonWidth,
                    height: LevelDesignerDefaults.buttonHeight
                )
            )
            
            let positionX = CGFloat(i + 1) * LevelDesignerDefaults.interButtonSpace + (CGFloat(i) + 0.5) * buttonWidth
            let positionY = LevelDesignerDefaults.buttonHeight/2 + LevelDesignerDefaults.interButtonSpace
            
            button.position = CGPoint(x: positionX, y: positionY)
            button.setLabelWithText(LevelDesignerDefaults.buttonNames[i], andFont: nil, withColor: LevelDesignerDefaults.buttonLabelColor)
            button.name = LevelDesignerDefaults.buttonNames[i]
            button.addTarget(self, selector: LevelDesignerDefaults.selectorButtonClicked, withObject: button, forControlEvent: AGButtonControlEvent.TouchUpInside)
            self.panelButtons.append(button)
            
            self.addChild(button)
        }
    }
    
    func buttonDidClicked(sender: AGSpriteButton?) {
        if let selectedButtonName = sender?.name {
            self.currentOpticalDeviceMode = selectedButtonName;
            updateButtonAppearance(selectedButton: sender);
        }
    }
    
    func updateButtonAppearance(#selectedButton: AGSpriteButton?) {
        for button in self.panelButtons {
            if button == selectedButton {
                button.alpha = 1;
            } else {
                button.alpha = 0.5;
            }
        }
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
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
                    self.addChild(emitter)
                    emitter.zPosition = 1000
                    emitter.delegate = self
                    emitter.fire()
                case LevelDesignerDefaults.buttonNameWall:
                    let wall = XWall(direction: CGVector(dx: -1, dy: 0))
                    wall.position = location
                    self.addChild(wall)
                case LevelDesignerDefaults.buttonNamePlanck:
                    let planck = XPlanck(mapping: [(XColor(index: 1), XNote.Null)])
                    planck.position = location
                    self.addChild(planck)
                    planck.zPosition = 998
                case LevelDesignerDefaults.buttonNameFlatLen:
                    let flatLen = XFlatLens(direction: CGVector(dx: 0, dy: 1), medium1: .Vacuum, medium2: .Water)
                    flatLen.position = location
                    self.addChild(flatLen)
                    flatLen.zPosition = 997
                    
                case LevelDesignerDefaults.buttonNameEraser:
                    let eraserFrame = CGRectMake(
                        location.x - LevelDesignerDefaults.eraserSize/2,
                        location.y - LevelDesignerDefaults.eraserSize/2,
                        LevelDesignerDefaults.eraserSize,
                        LevelDesignerDefaults.eraserSize);
                    for node in self.children {
                        if CGRectIntersectsRect(node.calculateAccumulatedFrame(), eraserFrame) {
                            if let xNode = node as? XNode {
                                node.removeFromParent();
                            }
                        }
                    }
                    
                default:
                    fatalError("optical device mode not recognized")
                    
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.enumerateChildNodesWithName(NodeName.xPhoton, usingBlock:  {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            var sprite = node as XPhoton
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
                    sprite.removeActionForKey(ActionKey.photonActionLinear)
                    sprite.removeFromParent()
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.flatLen != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.photon != 0)) {
                contactableNode = firstBody.node as XFlatLens
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
        contactableNode.contactWithPhoton(secondBody.node as XPhoton)
    }
    
    // MARK - XEmitterDelegate
    func emitterDidGenerateNewPhoton(emitter: XEmitter, photon: XPhoton, andAction action: SKAction) {
        photon.runAction(action, withKey: ActionKey.photonActionLinear)
        self.insertChild(photon, atIndex: 1)
    }
}
