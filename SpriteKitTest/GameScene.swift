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
    
    //MARK: - Sprite kit functionality
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.whiteColor()
        createCircleNode()
        moveCircleNode()
        self.addChild(circleNode)
    }
   
    //Setup and configuring the SKShapeNode object
    private func createCircleNode() {
        circleNode.path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)), radius: 20, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true).CGPath
        circleNode.fillColor = UIColor.redColor()
        circleNode.strokeColor = UIColor.blueColor()
        circleNode.lineWidth = 1
    }
    
    private func moveCircleNode() {
        circleNode.physicsBody = SKPhysicsBody()
        circleNode.physicsBody?.dynamic = false
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                self.destX = self.circleNode.position.x + CGFloat(data!.acceleration.x*100)
                self.destY = self.circleNode.position.y + CGFloat(data!.acceleration.y*200)
            })
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        let destXAction = SKAction.moveToX(destX, duration: 0.01)
        let destYAction = SKAction.moveToY(destY, duration: 0.01)
        self.circleNode.runAction(destXAction)
        self.circleNode.runAction(destYAction)
    }
}
