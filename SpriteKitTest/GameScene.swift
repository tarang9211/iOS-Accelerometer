//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by 580380 on 3/10/16.
//  Copyright (c) 2016 580380. All rights reserved.
//

import SpriteKit
import UIKit
import CoreMotion

class GameScene: SKScene {
    
    //MARK: - Global variables
    let motionManager = CMMotionManager()
    var circleNode = SKShapeNode()
    var destX : CGFloat = 0.0
    var destY : CGFloat = 0.0
    
    enum Collision : UInt32 {
        case ball = 1
        case wall = 2
    }
    
    //MARK: - Sprite kit functionality
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.whiteColor()
        createCircleNode()
        moveCircleNode()
        self.addChild(circleNode)
    }
   
    //Setup and configuring the SKShapeNode object
    private func createCircleNode() {
        //circleNode.path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)), radius: 20, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true).CGPath
        circleNode = SKShapeNode(circleOfRadius: 20)
        circleNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        circleNode.fillColor = UIColor.redColor()
        circleNode.strokeColor = UIColor.blueColor()
        circleNode.lineWidth = 1
    }
    
    private func moveCircleNode() {
        circleNode.physicsBody = SKPhysicsBody()
        circleNode.physicsBody?.dynamic = true
        circleNode.physicsBody?.affectedByGravity = false
        circleNode.physicsBody?.usesPreciseCollisionDetection = true
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                self.destX = self.circleNode.position.x + CGFloat(data!.acceleration.x*100)
                self.destY = self.circleNode.position.y + CGFloat(data!.acceleration.y*200)
            })
        }
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody!.dynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.categoryBitMask = Collision.wall.rawValue
        self.physicsBody!.collisionBitMask = Collision.ball.rawValue
        
    }
    
    private func clamp(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat{
        if value > max {
            return max
        }
        if value < min {
            return min
        }
        return value
    }
    
    override func update(currentTime: NSTimeInterval) {
        let ballRadius : CGFloat = 30.0
        let destXAction = SKAction.moveToX(destX, duration: 0.1)
        let destYAction = SKAction.moveToY(destY, duration: 0.1)
        destX = clamp(destX, min: ballRadius, max: frame.width - ballRadius)
        destY = clamp(destY, min: ballRadius, max: frame.height - ballRadius)
        self.circleNode.runAction(destXAction)
        self.circleNode.runAction(destYAction)
    }
}
