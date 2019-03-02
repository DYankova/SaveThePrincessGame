//
//  Castle.swift
//  DilyanaGame
//
//  Created by Dilyana Yankova on 24.02.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import Foundation
import SpriteKit

class Castle: SKSpriteNode {
    var dudesInCastle:Int = 0
    
    func setupCasle() {
        self.physicsBody?.categoryBitMask = BodyType.casle.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
    }
    
}

