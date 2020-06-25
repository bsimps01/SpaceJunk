//
//  GameScene.swift
//  SpaceJunk
//
//  Created by Benjamin Simpson on 6/11/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ship: SKSpriteNode!
    var livesArray: [SKSpriteNode]!
    var scoreLabel:SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var meteor: SKSpriteNode!
    
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
        
        let creatingDebris = SKAction.run {
            self.createDebris()
        }
        
        let createAction1 = SKAction.sequence([wait, creatingDebris])
        let repeatCreation1 = SKAction.repeatForever(createAction1)
        
        self.run(repeatCreation1)
        
        //gameOver()
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 50, y: self.frame.size.height - 70)
        scoreLabel.fontName = "Rockwell"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor.yellow
        score = 0
        
        self.addChild(scoreLabel)
        
        addLives()
        
    }
    
    
    override func didEvaluateActions() {
        checkCollisions(with: ship)
    }
    
    func createShip(){
        ship = SKSpriteNode(imageNamed: "playership")
        ship.size = CGSize(width: 60, height: 50)
        if self.view != nil{
            ship.position = CGPoint(x: 150, y: 50)
        }
        self.addChild(ship)
        
        //        let moveRight = SKAction.move(to: CGPoint(x: frame.size.width, y: 60), duration: 3)
        //        let moveLeft = SKAction.move(to: CGPoint(x: 0, y: 60), duration: 3)
        //        let sequenceAction2 = SKAction.sequence([moveRight, moveLeft])
        //        let repeatAction = SKAction.repeatForever(sequenceAction2)
        //        ship.run(repeatAction)
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
        let rotateAction = SKAction.rotate(byAngle: 4, duration: 1)
        let repeatAtion = SKAction.repeatForever(rotateAction)
        let groupAction = SKAction.group([sequenceAction1, rotateAction, repeatAtion])
        meteor.run(groupAction)
        
        let animationDuration: TimeInterval = 3
        
        var action = [SKAction]()
        
        action.append(SKAction.move(to: CGPoint(x: position, y: -meteor.size.height), duration: animationDuration))
        
    }
    
    func createDebris(){
        let debris = SKSpriteNode(imageNamed: "beam")
        debris.size = CGSize(width: 30, height: 30)
        debris.name = "debris"
        let randomDebris = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomDebris.nextInt())
        debris.position = CGPoint(x: position, y: self.frame.size.height + debris.size.height)
        self.addChild(debris)
        
        let someAction = SKAction.move(to: CGPoint(x: CGFloat(randomDebris.nextInt()), y: 0), duration: 3)
        debris.run(someAction).self
        
        let moveDownAction = SKAction.moveBy(x: 0, y: -90, duration: 4)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction1 = SKAction.sequence([moveDownAction,removeAction])
        let rotateAction = SKAction.rotate(byAngle: 8, duration: 1)
        let repeatAtion = SKAction.repeatForever(rotateAction)
        let groupAction = SKAction.group([sequenceAction1, rotateAction, repeatAtion])
        debris.run(groupAction)
        
        let animationDuration: TimeInterval = 6
        
        var action = [SKAction]()
        
        action.append(SKAction.move(to: CGPoint(x: position, y: -debris.size.height), duration: animationDuration))
        
    }
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.size = UIScreen.main.bounds.size
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(background)
    }
    
    func checkCollisions(with node: SKSpriteNode){
        enumerateChildNodes(withName: "meteor") { meteor, _ in
            if let meteor = meteor as? SKSpriteNode{
                if meteor.frame.intersects(self.ship.frame){
                    meteor.removeFromParent()
                    if self.livesArray.count > 0 {
                        let liveNode = self.livesArray.first
                        liveNode!.removeFromParent()
                        self.livesArray.removeFirst()
                        
                        if self.livesArray.count == 0 {
                            //Game Over Transistion screen
                            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                            let gameOver = GameOverScene(size: (self.view?.bounds.size)!)
                            gameOver.finalScore = self.score
                            self.view?.presentScene(gameOver, transition: transition)
                        }
                    }
                    
                }
            }
        }
        enumerateChildNodes(withName: "debris"){ debris, _ in
            if let debris = debris as? SKSpriteNode{
                if debris.frame.intersects(self.ship.frame){
                    debris.removeFromParent()
                    self.score += 1
                }
            }
        }
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches {
    //            let positionInScene = touch.location(in: self)
    //            let name = self.ship.atPoint(positionInScene).name
    //            let nodeFound = self.ship.atPoint(positionInScene)
    //
    //            if name != nil {
    //                nodeFound.removeFromParent()
    //            }
    //        }
    //        for touch in (touches as! Set<UITouch>) {
    //            let location = touch.location(in: self)
    //
    //            if ship.contains(location){
    //                ship.position = location
    //            }
    //        }
    //    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            ship.position = CGPoint(x: location.x, y: 50)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if let ship = ship{
            
        }
    }
    
    func addLives(){
        livesArray = [SKSpriteNode]()
        
        for live in 1...3 {
            let liveNode = SKSpriteNode(imageNamed: "playership")
            liveNode.size = CGSize(width: 25, height: 25)
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width, y: self.frame.size.height - 60)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    func gameOver(){
        let transition = SKAction.run{
            
            let gameOverScene = GameOverScene(size: (self.view?.bounds.size)!)
            gameOverScene.scaleMode = .aspectFill
            let effect = SKTransition.crossFade(withDuration: 1.0)
            if let spriteView = self.view{
                spriteView.presentScene(gameOverScene, transition: effect)
            }
        }
        
        let wait = SKAction.wait(forDuration: 6.0)
        let sequence = SKAction.group([wait, transition])
        self.run(sequence)
        
        
        
    }
}

