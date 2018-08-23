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
        
        let scale = 1.5
        
        //0 path
        let singlePath = UIBezierPath()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 13.594 * scale, y: -34.297 * scale))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //11 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 50.958 * scale, y: -14.5 * scale))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //22 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 43.568 * scale, y: 21.999 * scale))

        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //33 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: 10.805 * scale, y: 20.361 * scale))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //44 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: -29.852 * scale , y: -13.86 * scale))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //55 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x:-27.599 * scale, y: -7.521 * scale))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //66 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: -41.543 * scale, y: 14.058 * scale))
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //77 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 0, y: 0))
        singlePath.addLine(to: CGPoint(x: -19.931 * scale, y: 13.76 * scale))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: true, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        
        
        let move = SKAction.repeatForever(SKAction.sequence(actions))
        return move
    }
    static func kiteDeath() -> (SKAction, SKAction){
        var down: SKAction
        var left: SKAction
        var right: SKAction
        var leftAndRight: SKAction
        
        //
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: -500))
        
        down = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
        
        //
        path.removeAllPoints()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -25, y: 0))
        
        left = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
        
        //
        path.removeAllPoints()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 25, y: 0))
        
        right = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 50)
        
        let sequence = [left, right]
        
        leftAndRight = SKAction.repeatForever(SKAction.sequence(sequence))
        
        return (down, leftAndRight)
    }
    
}
