//
//  GameScene.swift
//  DilyanaGame
//
//  Created by Dilyana Yankova on 23.02.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import AudioToolbox

enum BodyType:UInt32{
    case player = 1
    case building = 2
    case casle = 4
    case princess = 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var thePlayer: SKSpriteNode = SKSpriteNode()
    var moveSpeed:TimeInterval = 0.1
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    
    var gameOverLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "GameOver!"
        label.fontSize = 65
        return label
    }()
    
    var loveLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Yeah!You saved the princess"
        label.fontSize = 55
        return label
    }()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.3, dy: 0)
        
        swipeRightRec.addTarget(self, action: #selector(GameScene.swipeRight))
        swipeRightRec.direction = .right
        self.view?.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(GameScene.swipeLeft))
        swipeLeftRec.direction = .left
        self.view?.addGestureRecognizer(swipeLeftRec)
    
        swipeDownRec.addTarget(self, action: #selector(GameScene.swipeDown))
        swipeDownRec.direction = .down
        self.view?.addGestureRecognizer(swipeDownRec)
        
        swipeUpRec.addTarget(self, action: #selector(GameScene.swipeUp))
        swipeUpRec.direction = .up
        self.view?.addGestureRecognizer(swipeUpRec)
        
        rotateRec.addTarget(self, action: #selector(GameScene.rotatedView(_:) ))
        self.view?.addGestureRecognizer(rotateRec)
    
        tapRec.numberOfTapsRequired = 1
        tapRec.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(tapRec)
        
        if let somePlayer = self.childNode(withName: "Player") as? SKSpriteNode {
            thePlayer = somePlayer
            thePlayer.physicsBody?.isDynamic = false
            thePlayer.physicsBody?.affectedByGravity = false
            
            thePlayer.physicsBody?.categoryBitMask = BodyType.player.rawValue
            thePlayer.physicsBody?.collisionBitMask =  BodyType.casle.rawValue
            thePlayer.physicsBody?.contactTestBitMask = BodyType.building.rawValue | BodyType.casle.rawValue  | BodyType.princess.rawValue   //intersections
        }
        
        //find the Building
        for node in self.children {
            if (node.name == "Building"){
                if (node is SKSpriteNode) {
                    node.physicsBody?.categoryBitMask = BodyType.building.rawValue
                    node.physicsBody?.collisionBitMask = 0
                }
            } else if (node.name == "Girl"){
                if (node is SKSpriteNode) {
                    node.physicsBody?.categoryBitMask = BodyType.princess.rawValue
                    node.physicsBody?.collisionBitMask = 0
                }
            }
            
            if let aCastle = node as? Castle {
                aCastle.setupCasle()
                aCastle.dudesInCastle = 5
            }
        }
        
    }
    
    //MARK:  Gestures
    @objc func swipeRight(){
         move(theXAmount:  150, theYAmount: 0, theAnimation: "WalkFront")
    }
    
    @objc func swipeLeft(){
         move(theXAmount: -150, theYAmount: 0, theAnimation: "WalkFront")
    }
    
    @objc func swipeUp(){
        move(theXAmount: 0, theYAmount: 150, theAnimation: "WalkFront")
    }
    
    @objc func swipeDown(){
        move(theXAmount: 0, theYAmount: -150, theAnimation: "WalkFront")
    }
    
    @objc  func rotatedView(_ sender:UIRotationGestureRecognizer){
        if (sender.state == .began){
            
        }
        //rotate the image with gesture recognizer
        if (sender.state == .changed){
            _ = Measurement(value: Double(sender.rotation), unit: UnitAngle.radians).converted(to: .degrees).value
            thePlayer.zRotation = sender.rotation
        }
        if (sender.state == .ended){
            //implement
        }
    }
    
    //remove all gestures, only need to be call when presenting a new scene class
    func cleanUp (){
        for gesture in (self.view?.gestureRecognizers)!{
            self.view?.removeGestureRecognizer(gesture)
        }
    }
    
    func move(theXAmount: CGFloat, theYAmount: CGFloat, theAnimation: String){
        
        thePlayer.physicsBody?.isDynamic = true
        thePlayer.physicsBody?.affectedByGravity = true
        
        let wait: SKAction = SKAction.wait(forDuration: 0.05)
        
        let walkAnimation:SKAction = SKAction(named: theAnimation, duration : moveSpeed )!
        
        let moveAction:SKAction = SKAction.moveBy(x: theXAmount, y: theYAmount, duration: moveSpeed)
        
        let group:SKAction = SKAction.group([walkAnimation, moveAction])
        
        let finish: SKAction = SKAction.run {
            //when done walking stop moving of object
            self.thePlayer.physicsBody?.isDynamic = false
            self.thePlayer.physicsBody?.affectedByGravity = false
        }
        
         let seq : SKAction = SKAction.sequence([wait, group, finish] )
         thePlayer.run(seq)
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
        if (pos.y < 0) {
            //top half touch
        } else {
            //bottom half touch
//            moveDown()
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
   
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in self.children {
            if (node.name == "Building"){
                if (node.position.y > thePlayer.position.y){
                    node.zPosition = -250
                } else {
                     node.zPosition = 150
                }
            }
        }
    }
    
    //MARK: Phisical contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Buildings
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.building.rawValue) {
            gameOver()
            
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.building.rawValue) {
            gameOver()
            
            //Castle
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.casle.rawValue){
            gameOver()

        } else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.casle.rawValue){
            gameOver()
            
            //Princess
        } else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.princess.rawValue) {
           savePrincess()
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.princess.rawValue) {
            savePrincess()
        }
 }
    
    func gameOver() {
        removeAllChildren()
        addChild(gameOverLabel)
        let background = SKSpriteNode(imageNamed: "game-over")
        background.position = CGPoint(x: frame.size.width / 22 , y: frame.size.height / 12)
        addChild(background)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func savePrincess() {
        removeAllChildren()
        addChild(loveLabel)
        let background = SKSpriteNode(imageNamed: "love")
        background.position = CGPoint(x: frame.size.width / 5, y: frame.size.height / 5 )
        addChild(background)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
