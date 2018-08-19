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
    static let kiteAttacher: UInt32 = 0x1 << 7
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
    private var attacherPath = UIBezierPath()
    
    //Comunidade
    var sky: [SKSpriteNode] = []
    var community: [SKSpriteNode] = []
    var pipa = SKSpriteNode()
    var kiteAttacher = SKSpriteNode()
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
        createAttacher()
        
        createKite()
        animateKite()
        
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
            casasCircular[i].setScale(0.25)
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
        
        //pipa.physicsBody?.mass = 1
        
        //print("MASSA DA PIPA: ",pipa.physicsBody?.mass)
        pipa.physicsBody?.collisionBitMask = 0
        
        //criando o atlas
        let kiteAnimatedAtlas = SKTextureAtlas(named: "Pipa")
        var flyFrames: [SKTexture] = []
        
        let numImages = kiteAnimatedAtlas.textureNames.count
        
        for i in 0..<numImages{
            let kiteTextureName = String(format: "tentativa1_%05d", i)
            flyFrames.append(kiteAnimatedAtlas.textureNamed(kiteTextureName))
        }
        kiteFlyingFrames = flyFrames
        
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
    
    func createAttacher(){
        //atrelando
        kiteAttacher = childNode(withName: "attacher") as! SKSpriteNode
        kiteAttacher.physicsBody?.collisionBitMask = 0
        
        
        let move = AnimationPath.get()
        kiteAttacher.run(move)
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
            pipa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
            kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
        }else{
            pipa.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pipa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
            kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
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
    
    func animateKite(){
        let actionRepeatForever = SKAction.repeatForever(SKAction.animate(with: kiteFlyingFrames, timePerFrame: 0.04, resize: false, restore: false))
        
//        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: {_ in
//            let kiteSize = CGSize(width: self.pipa.texture!.size().width * 0.1, height: self.pipa.texture!.size().height * 0.1)
//
//            self.pipa.physicsBody = SKPhysicsBody(texture: self.pipa.texture!, size: kiteSize)
//            self.pipa.physicsBody?.categoryBitMask = PhysicsCatagory.pipa
//        })
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block:{_ in
            print("posição da bodega: ", self.kiteAttacher.position)
            
            
            })
        
        pipa.run(actionRepeatForever, withKey: "FlyingKite")
    }
    func recreateKitePhysicsBody(){
        let kiteSize = CGSize(width: pipa.texture!.size().width * 0.1, height: pipa.texture!.size().height * 0.1)
        
        pipa.physicsBody = SKPhysicsBody(texture: pipa.texture!, size: kiteSize)
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
            community[2].position = CGPoint(x: 1930.375, y: 140)
            community[2].physicsBody = communityPhysicsBody[2] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[2].position = CGPoint(x: 1930.375, y: 219.75)
        }
        else if(bodyB == PhysicsCatagory.community[1] && PhysicsCatagory.communityAlreadyHit[1] == false){
            PhysicsCatagory.communityAlreadyHit[0] = false
            PhysicsCatagory.communityAlreadyHit[1] = true
            
            //print("hora do community 0 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[0].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[0].position = CGPoint(x: 1986.01, y: 154.6)
            community[0].physicsBody = communityPhysicsBody[0] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[0].position = CGPoint(x: 1985.75, y: 219.75)
        }
        else if(bodyB == PhysicsCatagory.community[2] && PhysicsCatagory.communityAlreadyHit[2] == false){
            PhysicsCatagory.communityAlreadyHit[1] = false
            PhysicsCatagory.communityAlreadyHit[2] = true
            
            //print("hora do community 1 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[1].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[1].position = CGPoint(x: 1985.749, y: 154)
            community[1].physicsBody = communityPhysicsBody[1] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[1].position = CGPoint(x: 1985.75, y: 219.75)
        }
        
        //
        if(bodyB == PhysicsCatagory.pipa){
            //self.view?.window?.rootViewController?.performSegue(withIdentifier: "gameOver", sender: self)
            print("Entrou")
        }
        
        
        
        //print("o contato foi entre \(contact.bodyA.node?.name) e \(contact.bodyB.node?.name) bodyB: \(bodyB) e pipa: \(PhysicsCatagory.pipa)")
        
    }
}
