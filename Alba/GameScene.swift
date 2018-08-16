//
//  GameScene.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory {
    static let pipaTeste : UInt32 = 0x1 << 1
    static let testeCasa : UInt32 = 0x1 << 2
    static let pipaRival : UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    

    //Favela
    var testeCasa = SKSpriteNode()
    var pipaTeste = SKSpriteNode()
    var pipas = SKNode()
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    override func didMove(to view: SKView) {
 
        testeCasa = SKSpriteNode(imageNamed: "testeCasa")
        testeCasa.setScale(0.5)
        testeCasa.position = CGPoint(x: self.frame.width / 2, y: 0 + testeCasa.frame.height / 2)
    
        //Fisica e Colisão
        testeCasa.physicsBody = SKPhysicsBody(rectangleOf: testeCasa.size)
        testeCasa.physicsBody?.categoryBitMask = PhysicsCatagory.testeCasa
        testeCasa.physicsBody?.collisionBitMask = PhysicsCatagory.pipaTeste
        testeCasa.physicsBody?.contactTestBitMask = PhysicsCatagory.pipaTeste
        testeCasa.physicsBody?.affectedByGravity = false
        testeCasa.physicsBody?.isDynamic = false
        
        self.addChild(testeCasa)
        
        
        pipaTeste = SKSpriteNode(imageNamed: "pipaTeste")
        pipaTeste.size = CGSize(width: 60, height: 70)
        pipaTeste.position = CGPoint(x: self.frame.width / 2 - pipaTeste.frame.width, y: self.frame.height / 2)
        
        pipaTeste.physicsBody = SKPhysicsBody(circleOfRadius: pipaTeste.frame.height / 2)
        pipaTeste.physicsBody?.categoryBitMask = PhysicsCatagory.pipaTeste
        pipaTeste.physicsBody?.collisionBitMask = PhysicsCatagory.testeCasa | PhysicsCatagory.pipaRival
        pipaTeste.physicsBody?.contactTestBitMask = PhysicsCatagory.testeCasa | PhysicsCatagory.pipaRival
        pipaTeste.physicsBody?.affectedByGravity = true
        pipaTeste.physicsBody?.isDynamic = true
        
        self.addChild(pipaTeste)
        
        
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            gameStarted = true
            
            let spawn  = SKAction.run({
                () in
                
                self.createPipasRivais()
            })
            
            let delay = SKAction.wait(forDuration: 8.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
        
            pipaTeste.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pipaTeste.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
        }else{
            pipaTeste.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pipaTeste.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
        }
     
    }
    
    func createPipasRivais(){
        pipas = SKNode()
        
        let pipaRival = SKSpriteNode(imageNamed: "pipaRival")
        
        pipaRival.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 300)
        pipaRival.size = CGSize(width: 60, height: 70)
        
        
        let distance = CGFloat(self.frame.width + pipas.frame.width)
        let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
        let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        pipaRival.run(moveAndRemove)
        
  
        
        pipas.addChild(pipaRival)
        
        self.addChild(pipas)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    
    }
}
