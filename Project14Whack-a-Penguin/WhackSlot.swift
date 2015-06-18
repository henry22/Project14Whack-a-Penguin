//
//  WhackSlot.swift
//  Project14Whack-a-Penguin
//
//  Created by Henry on 6/17/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var visible = false
    var isHit = false
    
    var charNode: SKSpriteNode!
    
    func configueAtPosition(pos: CGPoint) {
        position = pos
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        //position it slightly higher than the slot itself
        cropNode.position = CGPoint(x: 0, y: 15)
        //putting it to the front of other nodes
        cropNode.zPosition = 1
        //stop the crop node from doing anything
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        //the character node is added to the crop node
        cropNode.addChild(charNode)
        //the crop node added to the slot
        addChild(cropNode)
    }
    
    func show(#hideTime: Double) {
        if visible { return }
        
        charNode.runAction(SKAction.moveByX(0, y: 80, duration: 0.05))
        visible = true
        isHit = false
        
        if RandomInt(min: 0, max: 2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        runAfterDelay(hideTime * 3.5) { [unowned self] in
            self.hide()
        }
    }
    
    //the penguin moves back down the screen into its hole
    func hide() {
        if !visible { return }
        
        charNode.runAction(SKAction.moveByX(0, y: -80, duration: 0.05))
        visible = false
    }
}
