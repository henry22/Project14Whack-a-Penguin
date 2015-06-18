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
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
