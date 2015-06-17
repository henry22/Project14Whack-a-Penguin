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
    func configueAtPosition(pos: CGPoint) {
        position = pos
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
}
