//
//  GameScene.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, XEmitterDelegate, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
    }

    var count = 0;
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if self.count == 0 {
                let mirror = XFlatMirror(direction: CGVector(dx: 1, dy: -1))
                mirror.position = location
                self.addChild(mirror)
                mirror.zPosition = 999
                count++
            } else if self.count == 1 {
                let planck = XPlanck(mapping: [(XColor(index: 1), XNote.Null)])
                planck.position = location
                self.addChild(planck)
                planck.zPosition = 998
                count++
            } else if self.count == 2 {
                let wall = XWall(direction: CGVector(dx: -1, dy: 0))
                wall.position = location
                self.addChild(wall)
                count++
            } else if self.count == 3 {
                let convexLen = XConvexLens(focus: 5, direction: CGVector(dx: 0, dy: 1))
                convexLen.position = location
                self.addChild(convexLen)
//                convexLen.zPosition = 997
                count++
            } else {
                let emitter = XEmitter(appearanceColor: XColor(index: random()%8), direction: CGVector(dx: 1, dy: 0))
                emitter.position = location
                self.addChild(emitter)
                emitter.zPosition = 1000
                emitter.delegate = self
                emitter.fire()
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.convexLen != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.photon != 0)) {
                contactableNode = firstBody.node as XConvexLens
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
