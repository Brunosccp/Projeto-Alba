//
//  Reserva3.swift
//  Alba
//
//  Created by Bruno Rocca on 16/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import SpriteKit


class AnimationPath{
    static func get() -> SKAction{
        var action: SKAction
        var actions: [SKAction] = []
        
        let divider = 8.0
        
        //0 path
        let singlePath = UIBezierPath()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 13.594, y: -34.297))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //11 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 50.958, y: -14.5))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //22 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 43.568, y: 21.999))

        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //33 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 10.805, y: 20.361))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //44 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: -29.852 , y: -13.86))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //55 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x:-27.599 , y: -7.521))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //66 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: -41.543, y: 14.058))
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //77 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: -19.931, y: 13.76))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        
        
        let move = SKAction.repeatForever(SKAction.sequence(actions))
        return move
    }
    
}
