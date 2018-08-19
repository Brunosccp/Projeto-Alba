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
        singlePath.move(to: CGPoint(x: 67.927, y: 348.797))
        singlePath.addLine(to: CGPoint(x: 81.521, y: 314.5))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //11 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 81.521, y: 314.5))
        singlePath.addLine(to: CGPoint(x: 132.479, y: 300))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //22 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 132.479, y: 300))
        singlePath.addLine(to: CGPoint(x: 176.047, y: 321.999))

        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //33 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 176.047, y: 321.999))
        singlePath.addLine(to: CGPoint(x: 186.852, y: 342.36))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //44 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 186.852, y: 342.36))
        singlePath.addLine(to: CGPoint(x: 157 , y: 328.5))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //55 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 157, y: 328.5))
        singlePath.addLine(to: CGPoint(x:129.401 , y: 320.979))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //66 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 129.401, y: 320.979))
        singlePath.addLine(to: CGPoint(x: 87.858, y: 335.037))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        //77 path
        singlePath.removeAllPoints()
        singlePath.move(to: CGPoint(x: 87.858, y: 335.037))
        singlePath.addLine(to: CGPoint(x: 67.927, y: 348.797))
        
        action = SKAction.follow(singlePath.cgPath, asOffset: false, orientToPath: false, duration: 3.6 / divider)
        actions.append(action)
        
        
        
        let move = SKAction.repeatForever(SKAction.sequence(actions))
        return move
    }
    private func actionCreater(){
        
    }
}
