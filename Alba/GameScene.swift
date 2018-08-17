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
    
    static let createTriggerCategory: UInt32 = 0x1 << 4
    static let deleteTriggerCategory: UInt32 = 0x1 << 5
}

class GameScene: SKScene {

    //Comunidade
    var casas = SKSpriteNode()
    var pipas = SKNode()
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    //Gatilhos
    var createTrigger = SKSpriteNode()
    
    //Path para as casas andarem
    private var path = UIBezierPath()
    
    var sky = SKSpriteNode()
    var casasAlpha = SKSpriteNode()
    var pipa = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createTrigger = childNode(withName: "createTrigger") as! SKSpriteNode
        sky = childNode(withName: "ceu1") as! SKSpriteNode
        
        
        
        
        //criando caminho das casas
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -1000, y: 0))
        
        createHouses()
        
        pipa = childNode(withName: "pipa") as! SKSpriteNode
        
        pipa.physicsBody = SKPhysicsBody(circleOfRadius: pipa.frame.height / 2)
        pipa.physicsBody?.categoryBitMask = PhysicsCatagory.pipaTeste
        pipa.physicsBody?.collisionBitMask = PhysicsCatagory.testeCasa | PhysicsCatagory.pipaRival
        pipa.physicsBody?.contactTestBitMask = PhysicsCatagory.testeCasa | PhysicsCatagory.pipaRival
        pipa.physicsBody?.affectedByGravity = true
        pipa.physicsBody?.isDynamic = true
    }
    
    //função que cria as casas com o physics body em relação ao alpha da textura
    func createHouses(){
        //pegando somente a textura da imagem
        let casasTextura = SKTexture(imageNamed: "comunidade1")
        
        //precisa-se criar uma node com física circular antes de criar a fisica pelo alpha da img
        let casasCircular = SKSpriteNode(texture: casasTextura)
        casasCircular.physicsBody = SKPhysicsBody(circleOfRadius: max(casasCircular.size.width / 2, casasCircular.size.height / 2))
        casasCircular.setScale(0.3)
        
        //criando a física pelo alpha da textura
        casasAlpha = childNode(withName: "comunidade1") as! SKSpriteNode
        casasAlpha.physicsBody = SKPhysicsBody(texture: casasTextura,
                                               size: CGSize(width: casasCircular.size.width,
                                                            height: casasCircular.size.height))
        
        //Fisica e Colisão
        casasAlpha.physicsBody?.categoryBitMask = PhysicsCatagory.testeCasa
        casasAlpha.physicsBody?.collisionBitMask = PhysicsCatagory.pipaTeste
        casasAlpha.physicsBody?.contactTestBitMask = PhysicsCatagory.pipaTeste
        casasAlpha.physicsBody?.affectedByGravity = false
        casasAlpha.physicsBody?.isDynamic = false
        casasAlpha.physicsBody?.pinned = false
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
        casasAlpha.run(move)
        
        
        //casasAlpha.zRotation = 90
        //self.addChild(casasAlpha)
    }
    func createSky(){
        
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
            
        
            pipa.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pipa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }else{
            pipa.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pipa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
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
