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
    var sky: [SKSpriteNode] = []
    var community: [SKSpriteNode] = []
    var pipa = SKSpriteNode()

    //Frames da animação da pipa
    private var kiteFlyingFrames: [SKTexture] = []

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
            community.append(childNode(withName: "comunidade\(i+1)") as! SKSpriteNode)
            
            //salvando as propiedades físicas da comunidade na lista
            communityPhysicsBody.append(SKPhysicsBody(texture: comunidadeTextura[i],
                                                          size: CGSize(width: casasCircular[i].size.width, height: casasCircular[i].size.height)))
            
            community[i].physicsBody = communityPhysicsBody[i]
        }
        
        //Fisica e Colisão
        for i in 0...2{
            community[i].physicsBody?.categoryBitMask = PhysicsCatagory.community[i]
            community[i].physicsBody?.collisionBitMask = PhysicsCatagory.pipa
            community[i].physicsBody?.contactTestBitMask = PhysicsCatagory.pipa
            community[i].physicsBody?.affectedByGravity = false
            community[i].physicsBody?.isDynamic = false
            community[i].physicsBody?.pinned = false
        }
        //fazendo action de comunidades irem como uma esteira para a esquerda
        for i in 0...2{
            let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
            community[i].run(move)
        }
        
    }
    func createSky(){
        //ligando os céus do gameScene com o código
        for i in 0...2{
            sky.append(childNode(withName: "ceu\(i+1)") as! SKSpriteNode)
            
            //ligando a movimentação para a esquerda com os céus
            let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
            sky[i].run(move) 
        }
        
        
        
        
    }
    func createKite(){
        pipa = childNode(withName: "pipa") as! SKSpriteNode
        
        //pegando o tamanho da textura da pipa e convertendo para a escala 0.5
        let kiteSize = CGSize(width: pipa.texture!.size().width * 0.5, height: pipa.texture!.size().height * 0.5)
        
        pipa.physicsBody = SKPhysicsBody(texture: pipa.texture!, size: kiteSize)
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
            pipa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
        }else{
            pipa.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pipa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
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
        
        //verificando se as comunidades bateram no trigger, assim joga elas e o céu para o final da esteira
        if(bodyB == PhysicsCatagory.community[0] && PhysicsCatagory.communityAlreadyHit[0] == false){
            PhysicsCatagory.communityAlreadyHit[2] = false
            PhysicsCatagory.communityAlreadyHit[0] = true
            
            //print("hora do community 2 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[2].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[2].position = CGPoint(x: 2316.201, y: 167.5)
            community[2].physicsBody = communityPhysicsBody[2] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[2].position = CGPoint(x: 2316.201, y: 188.7)
        }
        else if(bodyB == PhysicsCatagory.community[1] && PhysicsCatagory.communityAlreadyHit[1] == false){
            PhysicsCatagory.communityAlreadyHit[0] = false
            PhysicsCatagory.communityAlreadyHit[1] = true
            
            //print("hora do community 0 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[0].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[0].position = CGPoint(x: 2382.951, y: 184.7)
            community[0].physicsBody = communityPhysicsBody[0] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[0].position = CGPoint(x: 2382.651, y: 188.7)
        }
        else if(bodyB == PhysicsCatagory.community[2] && PhysicsCatagory.communityAlreadyHit[2] == false){
            PhysicsCatagory.communityAlreadyHit[1] = false
            PhysicsCatagory.communityAlreadyHit[2] = true
            
            //print("hora do community 1 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[1].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[1].position = CGPoint(x: 2382.951, y: 187.7)
            community[1].physicsBody = communityPhysicsBody[1] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[1].position = CGPoint(x: 2382.65, y: 188.7)
        }
        
        //print("o contato foi entre \(bodyANode.name!) e \(bodyBNode.name!)")
    }
}
