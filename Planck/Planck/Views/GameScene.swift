//
//  GameScene.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Avenir-Medium")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = XPhoton(illuminance: 0, color: XColor(), direction: CGVector(dx: 1, dy: 1))
            
            if sprite.parent != nil {
                sprite.removeActionForKey(ActionKey.photonActionLinear)
                let direction = CGVector(dx: -sprite.direction.dx, dy: sprite.direction.dy)
                sprite.setDirection(direction)
                sprite.runAction(SKAction.repeatActionForever(sprite.getAction()), withKey: ActionKey.photonActionLinear)
            } else {
                sprite.position = location
                sprite.runAction(SKAction.repeatActionForever(sprite.getAction()), withKey: ActionKey.photonActionLinear)
                self.addChild(sprite)
            }

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.enumerateChildNodesWithName(NodeName.xPhoton, usingBlock:  {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            var sprite = node as XPhoton
            if sprite.parent != nil {
                if sprite.position.x < 0 || sprite.position.x > 1024 {
                    sprite.removeActionForKey(ActionKey.photonActionLinear)
                    let direction = CGVector(dx: -sprite.direction.dx, dy: sprite.direction.dy)
                    sprite.setDirection(direction)
                    var position = sprite.position;
                    if position.x < 0 {
                        position.x = 0
                    } else {
                        position.x = 1024
                    }
                    sprite.position = position
                    sprite.runAction(SKAction.repeatActionForever(sprite.getAction()), withKey: ActionKey.photonActionLinear)
                }
                
                if sprite.position.y < 0 || sprite.position.y > 768 {
                    sprite.removeActionForKey(ActionKey.photonActionLinear)
                    let direction = CGVector(dx: sprite.direction.dx, dy: -sprite.direction.dy)
                    sprite.setDirection(direction)
                    var position = sprite.position;
                    if position.y < 0 {
                        position.y = 0
                    } else {
                        position.y = 768
                    }
                    sprite.position = position
                    sprite.runAction(SKAction.repeatActionForever(sprite.getAction()), withKey: ActionKey.photonActionLinear)
                }
            }
        })
    }
}
