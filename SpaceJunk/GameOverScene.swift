//
//  GameOverScene.swift
//  SpaceJunk
//
//  Created by Benjamin Simpson on 6/11/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var gameOverLabel = SKLabelNode(text: "Game Over")
    let scoreLabel = SKLabelNode()
    var finalScore = 0
    var playAgainLabel = SKSpriteNode(imageNamed: "bar")

    override init(size: CGSize) {
        // do initial configuration work here
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    override func didMove(to view: SKView) {
        addChild(gameOverLabel)
        gameOverLabel.fontSize = 32.0
        gameOverLabel.color = SKColor.white
        gameOverLabel.fontName = "Thonburi-Bold"
        gameOverLabel.position = CGPoint(x: size.width / 2, y: 500)
        
        playAgainLabel.position = CGPoint(x: size.width / 2, y: 300)
        playAgainLabel.name = "Restart"
        playAgainLabel.size = CGSize(width: 200, height: 100)
        addChild(playAgainLabel)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if ((nodesArray.first?.name = "playAgainLabel") != nil) {
                let transition = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
    
//    func setFinalScore(){
//        if let score = finalScore{
//            scoreLabel = SKLabelNode(text: "Score: \(score)")
//            scoreLabel.position = CGPoint(x: 20, y: self.frame.size.height - 70)
//            scoreLabel.fontName = "Rockwell"
//            scoreLabel.fontSize = 50
//            scoreLabel.fontColor = UIColor.yellow
//            score = 0
//            
//            self.addChild(scoreLabel)
//        }
//    }
}
