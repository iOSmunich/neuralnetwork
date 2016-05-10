//
//  Scene.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa
import SpriteKit

class Scene: SKScene {
    
    private (set) var _sportTimer = SportTimer()
    
    private (set) var _label1    = SKLabelNode.init()
    private (set) var _label2    = SKLabelNode.init()
    private (set) var _label3    = SKLabelNode.init()
    
    
    
    private (set) var _diagram  = SKNode()
    
    private (set) var _lossVal  = 0.0
    private (set) var _lastSum  = 0.0
    private (set) var _last50Loss = [Double].init(count: 50, repeatedValue: 0)
    
    
    private (set) var _spline:SKShapeNode?
    
    
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        let _labelC = SKNode()
        
        
        _label1.position = CGPointMake(0, 15)
        _label1.name = "label1"
        _label1.fontSize = 12.0
        _label1.horizontalAlignmentMode = .Left
        _labelC.addChild(_label1)
        
        _label2.position = CGPointMake(0, 0)
        _label2.name = "label2"
        _label2.fontSize = 12.0
        _label2.horizontalAlignmentMode = .Left
        _labelC.addChild(_label2)
        
        _label3.position = CGPointMake(0, -15)
        _label3.name = "label2"
        _label3.fontSize = 12.0
        _label3.horizontalAlignmentMode = .Left
        _labelC.addChild(_label3)
        
        _labelC.position = CGPointMake(250, 150)
        addChild(_labelC)
        
        
        
        _diagram.position = CGPointMake(10, 10)
        addChild(_diagram)
        
        
        let xLine = SKSpriteNode.init(color: SKColor.greenColor(), size: CGSizeMake(200, 1))
        let yLine = SKSpriteNode.init(color: SKColor.greenColor(), size: CGSizeMake(1, 150))
        
        xLine.anchorPoint = CGPointMake(0, 0)
        yLine.anchorPoint = CGPointMake(0, 0)
        
        
        _diagram.addChild(xLine)
        _diagram.addChild(yLine)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        
        if global_trainingPaused {
            _sportTimer.pause()
            return
        } else {
            _sportTimer.start()
        }
        
        
        
        _lossVal = global_Err_Sum
        
        
        
        
        //use dist as loss function
        let dist = _last50Loss.dist
        _label1.text = "loss :" + dist
        _label2.text = "epoch:" + global_Epoch.description
        _label3.text = "time :" + _sportTimer.elapsedTime
        
        
        
        //optimal found
        if dist < 0.01 {
            global_trainingPaused = true
        }
        
        
        
        
        //fifo, store last 50 loss values
        _last50Loss.removeFirst()
        _last50Loss.append(_lossVal)
        
        
        
        
        
        
        //make spline points
        var points = [CGPoint].init(count: 50, repeatedValue: CGPointZero)
        
        for (idx,_) in points.enumerate() {
            
            
            let tmpX = CGFloat(idx*5)
            let tmpY = CGFloat(_last50Loss[idx]*100)
            let tmp  = CGPointMake(tmpX,tmpY)
            
            
            points[idx] = tmp
        }
        
        
        
        //redraw spline
        _spline?.removeFromParent()
        _spline = SKShapeNode.init(splinePoints: &points, count: 50)
        _spline?.strokeColor = SKColor.redColor()
        _diagram.addChild(_spline!)
    }
    
    
    override func mouseUp(theEvent: NSEvent) {
        let p = theEvent.locationInNode(self)
        
        _diagram.position = p
        print(p)
    }
    
    
    func reset(){
        
        _sportTimer.reset()
        
        
        _label1.text = "loss :" + 0
        _label2.text = "epoch:" + 0
        _label3.text = "time :" + 0
        
        
        _lossVal  = 0.0
        _lastSum  = 0.0
        _last50Loss.reset()
        
        _spline?.removeAllChildren()
        _spline?.removeFromParent()
        
    }
}





