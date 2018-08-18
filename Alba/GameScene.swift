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
    static let pipa : UInt32 = 0x1 << 1
    
    static let community : [UInt32] = [0x1 << 2, 0x1 << 3, 0x1 << 4]
    static var communityAlreadyHit: [Bool] = [false, false, false]
    
    static let pipaRival : UInt32 = 0x1 << 5
    
    static let communityTrigger: UInt32 = 0x1 << 6
}

class GameScene: SKScene {

    //Comunidade
    var pipas = SKNode()
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    //Gatilhos
    var comunnityTrigger = SKSpriteNode()
    
    //Path para as casas andarem
    private var path = UIBezierPath()
    
    //Comunidade
    var sky = SKSpriteNode()
    var comunidade: [SKSpriteNode] = []
    var pipa = SKSpriteNode()
    
    //Fisica da comunidade
    var communityPhysicsBody: [SKPhysicsBody] = []
    
    override func didMove(to view: SKView) {
        
        //criando caminho das casas
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -5000, y: 0))
        
        createSky()
        createHouses()
        
        createTriggers()
        
        createKite()
        
        self.physicsWorld.contactDelegate = self
    }
    
    //função que cria as casas com o physics body em relação ao alfa da textura
    func createHouses(){
        var casasCircular: [SKSpriteNode] = []
        
        //pegando somente a textura das imagens
        var comunidadeTextura : [SKTexture] = []
        for i in 0...2{
            comunidadeTextura.append(SKTexture(imageNamed: "comunidade\(i+1)"))
        }
        
        //precisa-se criar node com física circular antes de criar a fisica pelo alfa da img
        for i in 0...2{
            casasCircular.append(SKSpriteNode(texture: comunidadeTextura[i]))
            casasCircular[i].physicsBody = SKPhysicsBody(circleOfRadius: max(casasCircular[i].size.width / 2, casasCircular[i].size.height / 2))
            casasCircular[i].setScale(0.3)
        }
        
        //criando a física pelo alfa da textura
        for i in 0...2{
            comunidade.append(childNode(withName: "comunidade\(i+1)") as! SKSpriteNode)
            
            //salvando as propiedades físicas da comunidade na lista
            communityPhysicsBody.append(SKPhysicsBody(texture: comunidadeTextura[i],
                                                          size: CGSize(width: casasCircular[i].size.width, height: casasCircular[i].size.height)))
            
            comunidade[i].physicsBody = communityPhysicsBody[i]
        }
        
        //Fisica e Colisão
        for i in 0...2{
            comunidade[i].physicsBody?.categoryBitMask = PhysicsCatagory.community[i]
            comunidade[i].physicsBody?.collisionBitMask = PhysicsCatagory.pipa
            comunidade[i].physicsBody?.contactTestBitMask = PhysicsCatagory.pipa
            comunidade[i].physicsBody?.affectedByGravity = false
            comunidade[i].physicsBody?.isDynamic = false
            comunidade[i].physicsBody?.pinned = false
        }
        
        for i in 0...2{
            let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
            comunidade[i].run(move)
        }
        
    }
    func createSky(){
        sky = childNode(withName: "ceu1") as! SKSpriteNode
        
    }
    func createKite(){
        pipa = childNode(withName: "pipa") as! SKSpriteNode
        
        pipa.physicsBody = SKPhysicsBody(circleOfRadius: pipa.frame.height / 2)
        pipa.physicsBody?.categoryBitMask = PhysicsCatagory.pipa
        pipa.physicsBody?.collisionBitMask = PhysicsCatagory.community[0] | PhysicsCatagory.community[1] | PhysicsCatagory.community[2] | PhysicsCatagory.pipaRival
        pipa.physicsBody?.contactTestBitMask = PhysicsCatagory.community[0]|PhysicsCatagory.community[1] | PhysicsCatagory.community[2] | PhysicsCatagory.pipaRival
        pipa.physicsBody?.affectedByGravity = true
        pipa.physicsBody?.isDynamic = true
    }
    func createTriggers(){
        comunnityTrigger = childNode(withName: "communityTrigger") as! SKSpriteNode
        
        comunnityTrigger.physicsBody = SKPhysicsBody(rectangleOf: comunnityTrigger.size)
        
        comunnityTrigger.physicsBody?.categoryBitMask = PhysicsCatagory.communityTrigger
        comunnityTrigger.physicsBody?.contactTestBitMask = PhysicsCatagory.community[0] | PhysicsCatagory.community[1] | PhysicsCatagory.community[2]
        comunnityTrigger.physicsBody?.collisionBitMask = 0
        comunnityTrigger.physicsBody?.affectedByGravity = false
        
        
        
        self.physicsWorld.contactDelegate = self
        
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
extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        if(bodyB == PhysicsCatagory.community[0] && PhysicsCatagory.communityAlreadyHit[0] == false){
            PhysicsCatagory.communityAlreadyHit[2] = false
            PhysicsCatagory.communityAlreadyHit[0] = true
            
            print("hora do community 2 ir para a posicao final")
            comunidade[2].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            comunidade[2].position = CGPoint(x: 2316.201, y: 167.5)
            comunidade[2].physicsBody = communityPhysicsBody[2] //reativando a física
            
        }
        else if(bodyB == PhysicsCatagory.community[1] && PhysicsCatagory.communityAlreadyHit[1] == false){
            PhysicsCatagory.communityAlreadyHit[0] = false
            PhysicsCatagory.communityAlreadyHit[1] = true
            
            print("hora do community 0 ir para a posicao final")
            comunidade[0].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            comunidade[0].position = CGPoint(x: 2382.951, y: 184.7)
            comunidade[0].physicsBody = communityPhysicsBody[0] //reativando a física
        }
        else if(bodyB == PhysicsCatagory.community[2] && PhysicsCatagory.communityAlreadyHit[2] == false){
            PhysicsCatagory.communityAlreadyHit[1] = false
            PhysicsCatagory.communityAlreadyHit[2] = true
            
            print("hora do community 1 ir para a posicao final")
            comunidade[1].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            comunidade[1].position = CGPoint(x: 2382.951, y: 187.7)
            comunidade[1].physicsBody = communityPhysicsBody[1] //reativando a física
        }
        
        //print("o contato foi entre \(bodyANode.name!) e \(bodyBNode.name!)")
    }
}
