//
//  GameScene.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let kiteAttacher: UInt32 = 0x1 << 1
    static let community : [UInt32] = [0x1 << 2, 0x1 << 3, 0x1 << 4]
    static var communityAlreadyHit: [Bool] = [false, false, false]
    
    static let pipaRival : UInt32 = 0x1 << 5
    
    static let communityTrigger: UInt32 = 0x1 << 6
}

class GameScene: SKScene {

    var viewController: UIViewController?
    
    //Comunidade
    var pipas = SKNode()
    var moveAndRemove = SKAction()
    
    var gameStarted = true
    
    //Gatilhos
    var comunnityTrigger = SKSpriteNode()
    
    //Path para as casas andarem
    private var path = UIBezierPath()
    private var attacherPath = UIBezierPath()
    
    //Comunidade
    var sky: [SKSpriteNode] = []
    var community: [SKSpriteNode] = []
    var kite = SKSpriteNode()
    var kiteAttacher = SKSpriteNode()
    var kiteLine = UIBezierPath()
    
    //Frames da animação da pipa
    private var kiteFlyingFrames: [SKTexture] = []

    //Fisica da comunidade
    var communityPhysicsBody: [SKPhysicsBody] = []
    
    //microfone
    var blow: BlowIdentifier? = nil

    
    override func didMove(to view: SKView) {
        
        
        //criando caminho das casas
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -1000, y: 0))
        
        //criando cenário
        createSky()
        createHouses()
        
        //criando gatilho para esteira
        createTriggers()
        
        //criando pipa e seu attacher
        createAttacher()
        createKite()
        animateKite()
        createKiteLine()
        
        //
        startObserveBlow()
        
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
            community[i].physicsBody?.categoryBitMask = PhysicsCategory.community[i]
            community[i].physicsBody?.collisionBitMask = PhysicsCategory.kiteAttacher
            community[i].physicsBody?.contactTestBitMask = PhysicsCategory.kiteAttacher
            community[i].physicsBody?.affectedByGravity = false
            community[i].physicsBody?.isDynamic = false
            community[i].physicsBody?.pinned = false
        }
        //fazendo action de comunidades irem como uma esteira para a esquerda
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
        for i in 0...2{
            community[i].run(SKAction.repeatForever(move))
        }
        
    }
    func createSky(){
        //ligando os céus do gameScene com o código
        for i in 0...2{
            sky.append(childNode(withName: "ceu\(i+1)") as! SKSpriteNode)
            
            //ligando a movimentação para a esquerda com os céus
            let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
            sky[i].run(SKAction.repeatForever(move))
        }
        
        
        
    }
    func createTriggers(){
        comunnityTrigger = childNode(withName: "communityTrigger") as! SKSpriteNode
        
        comunnityTrigger.physicsBody = SKPhysicsBody(rectangleOf: comunnityTrigger.size)
        
        comunnityTrigger.physicsBody?.categoryBitMask = PhysicsCategory.communityTrigger
        comunnityTrigger.physicsBody?.contactTestBitMask = PhysicsCategory.community[0] | PhysicsCategory.community[1] | PhysicsCategory.community[2]
        comunnityTrigger.physicsBody?.collisionBitMask = 0
        comunnityTrigger.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
    }
    
    func createKite(){
        kite = childNode(withName: "pipa") as! SKSpriteNode
        kite.physicsBody?.collisionBitMask = 0
        
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
    func createAttacher(){
        //atrelando com o gameScene
        kiteAttacher = childNode(withName: "attacher") as! SKSpriteNode
        
        //
        kiteAttacher.physicsBody?.collisionBitMask = 0
        kiteAttacher.physicsBody?.categoryBitMask = PhysicsCategory.kiteAttacher
        kiteAttacher.physicsBody?.contactTestBitMask = PhysicsCategory.community[0] | PhysicsCategory.community[1] | PhysicsCategory.community[2]
        
        let move = AnimationPath.get()
        kiteAttacher.run(move)
    }
    func createKiteLine(){
        //
        kiteLine.move(to: CGPoint(x: 0, y: 100))
        kiteLine.addLine(to: kiteAttacher.position)
        
        let line = SKShapeNode()
        line.path = kiteLine.cgPath
        line.zPosition = -3
        line.strokeColor = UIColor.white
        line.lineWidth = 2
        addChild(line)
        
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true, block: {thread in
            self.kiteLine.removeAllPoints()
            self.kiteLine.move(to: CGPoint(x: 0, y: 100))
            self.kiteLine.addLine(to: self.kiteAttacher.position)
            
            line.path = self.kiteLine.cgPath
            
            if(self.gameStarted == false){
                thread.invalidate()
            }
        })
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
            
        
            kite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            kite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
            
            kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
        }else{
            kite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            kite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
            
            kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
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
        
        
        kite.run(actionRepeatForever, withKey: "FlyingKite")
    }
    func startObserveBlow(){
        Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block:{thread in
            //"teto! de sopro pra pipa nao subir muito
            if(self.kiteAttacher.position.y > 300){
                return
            }
            
            //pega a força do sopro (3 = forte, 2 = médio, 1 = fraco, 0 = nada)
            let blowStrenght = self.blow!.getAmplitude()
            print(self.blow!.getAmplitude())
            
            //dá o impulso de acordo com a força do sopro
            if(blowStrenght >= 3){
                self.kite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.kite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1.65))
                
                self.kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1.65))
            }else if(blowStrenght >= 2){
                self.kite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.kite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1.15))
                
                self.kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1.15))
            }else if(blowStrenght >= 1){
                self.kite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.kite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.65))
                
                self.kiteAttacher.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.kiteAttacher.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.65))
            }
            
            if(self.gameStarted == false){
                thread.invalidate()
            }
        })
    }

    
}
extension GameScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        //verificando se as comunidades bateram no trigger, assim joga elas e o céu para o final da esteira
        if(bodyB == PhysicsCategory.community[0] && PhysicsCategory.communityAlreadyHit[0] == false){
            PhysicsCategory.communityAlreadyHit[2] = false
            PhysicsCategory.communityAlreadyHit[0] = true
            
            //print("hora do community 2 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[2].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[2].position = CGPoint(x: 1930.375, y: 140)
            community[2].physicsBody = communityPhysicsBody[2] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[2].position = CGPoint(x: 1930.375, y: 219.75)
        }
        else if(bodyB == PhysicsCategory.community[1] && PhysicsCategory.communityAlreadyHit[1] == false){
            PhysicsCategory.communityAlreadyHit[0] = false
            PhysicsCategory.communityAlreadyHit[1] = true
            
            //print("hora do community 0 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[0].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[0].position = CGPoint(x: 1986.01, y: 154.6)
            community[0].physicsBody = communityPhysicsBody[0] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[0].position = CGPoint(x: 1985.75, y: 219.75)
        }
        else if(bodyB == PhysicsCategory.community[2] && PhysicsCategory.communityAlreadyHit[2] == false){
            PhysicsCategory.communityAlreadyHit[1] = false
            PhysicsCategory.communityAlreadyHit[2] = true
            
            //print("hora do community 1 ir para a posicao final")
            
            //jogando community para o final da esteira
            community[1].physicsBody = nil //desativando a fisica, pois se não a comunidade não muda de posição
            community[1].position = CGPoint(x: 1985.749, y: 154)
            community[1].physicsBody = communityPhysicsBody[1] //reativando a física
            
            //jogando o céu para o final da esteira
            sky[1].position = CGPoint(x: 1985.75, y: 219.75)
        }
        
        //testando se o kiteAttacher bateu numa das comunidades, no caso causando game over
        for i in 0...2{
            if (bodyA == PhysicsCategory.community[i] && bodyB == PhysicsCategory.kiteAttacher) ||
                (bodyB == PhysicsCategory.community[i] && bodyA == PhysicsCategory.kiteAttacher)
            {
                //parando toda gameScene para evitar memory leak
                self.removeAllActions()
                self.removeAllChildren()
                self.removeFromParent()
                
                
                //blow?.stop()
                gameStarted = false
                
                
                
                self.viewController?.performSegue(withIdentifier: "gameOver", sender: self)
                print("GAME OVER VIADO")
            }
        }
        
        
        
        //print("o contato foi entre \(contact.bodyA.node?.name) e \(contact.bodyB.node?.name) bodyB: \(bodyB)")
        
    }
}
