//
//  GameScene.swift
//  Project14Whack-a-Penguin
//
//  Created by Henry on 6/17/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var popupTime = 0.85
    
    var slots = [WhackSlot]()
    
    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    func createSlotAt(pos: CGPoint) {
        let slot = WhackSlot()
        slot.configueAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "chalkDuster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.fontSize = 48
        gameScore.horizontalAlignmentMode = .Left
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }

        runAfterDelay(1) { [unowned self] in
            self.createEnemy()
        }
    }
    
    func createEnemy() {
        //Decrease popupTime each time it's called
        popupTime *= 0.991
        
        //Shuffle the list of available slots
        slots.shuffle()
        //Make the first slot show itself
        slots[0].show(hideTime: popupTime)
        
        //Generate four random numbers to see if more slots should be shown
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 { slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        //Call itself again after a random delay
        runAfterDelay(RandomDouble(min: minDelay, max: maxDelay)) { [unowned self] in
            self.createEnemy()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        //find any touch, find out where it was tapped, then get a node array of all nodes at that point in the scene
        let nodes = nodesAtPoint(location) as! [SKNode]
        
        for node in nodes {
            if node.name == "charFriend" {
                //they shouldn't have whacked this penguin
                
                //It gets the parent of the parent of the node, and typecasts it as a WhackSlot
                let whackSlot = node.parent!.parent as! WhackSlot
                if !whackSlot.visible { continue }
                if whackSlot.isHit { continue }
                
                whackSlot.hit()
                score -= 5
                
                //plays a sound and optionally waits for the sound to finish playing before continuing
                runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                //they should have whacked this penguin
                
                let whackSlot = node.parent!.parent as! WhackSlot
                if !whackSlot.visible { continue }
                if whackSlot.isHit { continue }
                
                //the penguin visibly shrinks in the scene, as if they had been hit
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                whackSlot.hit()
                score += 1
                
                runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
