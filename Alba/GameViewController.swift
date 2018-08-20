//
//  GameViewController.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


//Essa é a capivara do SIGABRT
//
//    　　 /)─―ヘ
//　　　＿／　　　　＼
//　 ／　  　●　　　●丶
//　｜　　　　　　　▼　|
//　｜　　　　　　　亠ノ
//　 U￣U￣￣￣￣U
//
//Repasse no código para não sofrer com SIGABRT

//deixar esse troço global foi a unica solução, perdão william =(
var blow: BlowIdentifier?

class GameViewController: UIViewController {
    
    func theFunction(){
        struct Holder { static var called = false }
        
        if !Holder.called {
            Holder.called = true
            //do the thing
            print("uma vez na vida")
            blow = BlowIdentifier()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theFunction()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
        
        if let scene = GKScene(fileNamed: "GameScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                sceneNode.viewController = self
                sceneNode.blow = blow
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    //view.showsPhysics = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
