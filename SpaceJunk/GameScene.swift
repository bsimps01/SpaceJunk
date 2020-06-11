//
//  GameScene.swift
//  SpaceJunk
//
//  Created by Benjamin Simpson on 6/11/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
    var ship: SKSpriteNode!
  
    override func didMove(to view: SKView) {
        // Called when the scene has been displayed
        
        let wait = SKAction.wait(forDuration: 1.0)
        let creatingMeteor = SKAction.run {
            self.createMeteor()
        }
        let createAction = SKAction.sequence([wait, creatingMeteor])
        let repeatCreation = SKAction.repeatForever(createAction)
        
        self.run(repeatCreation)
        
        createShip()
        createBackground()
        
        let debris = SKSpriteNode(imageNamed: "beam")
        debris.size = CGSize(width: 50, height: 50)
        debris.position = CGPoint(x: 300, y: 300)
        self.addChild(debris)

    }
    
    override func didEvaluateActions() {
        checkCollisions(with: ship)
    }
    
    func createShip(){
        ship = SKSpriteNode(imageNamed: "playership")
        ship.size = CGSize(width: 60, height: 50)
        if self.view != nil{
            ship.position = CGPoint(x: 0, y: 0)
        }
        self.addChild(ship)
        
        let moveRight = SKAction.move(to: CGPoint(x: frame.size.width, y: 60), duration: 3)
        let moveLeft = SKAction.move(to: CGPoint(x: 0, y: 60), duration: 3)
        let sequenceAction2 = SKAction.sequence([moveRight, moveLeft])
        let repeatAction = SKAction.repeatForever(sequenceAction2)
        ship.run(repeatAction)
    }
    
    func createMeteor(){
        
        let meteor = SKSpriteNode(imageNamed: "meteorBrown")
        meteor.size = CGSize(width: 60, height: 60)
        meteor.name = "meteor"
        let randomMeteor = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomMeteor.nextInt())
        meteor.position = CGPoint(x: position, y: self.frame.size.height + meteor.size.height)
        self.addChild(meteor)
        
        let someAction = SKAction.move(to: CGPoint(x: CGFloat(randomMeteor.nextInt()), y: 0), duration: 3)
        meteor.run(someAction).self
        
        let moveDownAction = SKAction.moveBy(x: 0, y: -90, duration: 3)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction1 = SKAction.sequence([moveDownAction,removeAction])
        let rotateAction = SKAction.rotate(byAngle: 8, duration: 1)
        let repeatAtion = SKAction.repeatForever(rotateAction)
        let groupAction = SKAction.group([sequenceAction1, rotateAction, repeatAtion])
        meteor.run(groupAction)
        
        let animationDuration: TimeInterval = 6
        
        var action = [SKAction]()
        
        action.append(SKAction.move(to: CGPoint(x: position, y: -meteor.size.height), duration: animationDuration))
        


        
    }
    
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.size = UIScreen.main.bounds.size
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(background)
    }
    
    func checkCollisions(with node: SKSpriteNode){
        //var meteorHits: [SKSpriteNode] = []
        
        enumerateChildNodes(withName: "meteor") { meteor, _ in
        if let meteor = meteor as? SKSpriteNode{
            if meteor.frame.intersects(self.ship.frame){
                self.ship.removeFromParent()
                meteor.removeFromParent()
            }
        }
    }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let name = self.ship.atPoint(positionInScene).name
            let nodeFound = self.ship.atPoint(positionInScene)
            
            if name != nil {
                nodeFound.removeFromParent()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            
            if ship.contains(location){
                ship.position = location
            }
        }
    }
  
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

