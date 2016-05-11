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
    private (set) var _last50Loss = [Double].init(count: 50, repeatedValue: 1.0)
    private (set) var _last50Dist = [Double].init(count: 50, repeatedValue: 1.0)
    
    
    
    private (set) var _spline:SKShapeNode?
    
    
    
    private (set) var _showSpline = true
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        let _labelC = SKNode()
        _labelC.position = CGPointMake(285,190)
        addChild(_labelC)
        
        
        _label1.position = CGPointMake(0, 15)
        _label1.fontSize = 14.0
        _label1.horizontalAlignmentMode = .Left
        _labelC.addChild(_label1)
        
        _label2.position = CGPointMake(0, 0)
        _label2.fontSize = 14.0
        _label2.horizontalAlignmentMode = .Left
        _labelC.addChild(_label2)
        
        _label3.position = CGPointMake(0, -15)
        _label3.fontSize = 14.0
        _label3.horizontalAlignmentMode = .Left
        _labelC.addChild(_label3)
        
        
        
        
        
        _diagram.position = CGPointMake(10, 10)
        addChild(_diagram)
        
        
        let xLine = SKSpriteNode.init(color: SKColor.greenColor(), size: CGSizeMake(200, 1))
        let yLine = SKSpriteNode.init(color: SKColor.greenColor(), size: CGSizeMake(1, 150))
        
        xLine.anchorPoint = CGPointMake(0, 0)
        yLine.anchorPoint = CGPointMake(0, 0)
        
        
        _diagram.addChild(xLine)
        _diagram.addChild(yLine)
        
    }
    
    private var updateDelayer = 0 as Int
    
    override func update(currentTime: NSTimeInterval) {
        
        updateDelayer += 1
        updateDelayer = updateDelayer % 3
        
        if updateDelayer != 0 {
            return
        }
        
        
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
        
        
        _last50Dist.removeFirst()
        _last50Dist.append(_last50Loss.dist)
        
        
        if _showSpline {
            redrawSpline()
        }
        
        
    }
    
    
    func redrawSpline(){
        
        let count = _last50Dist.count
        //make spline points
        var points = [CGPoint].init(count: count, repeatedValue: CGPointZero)
        
        for (idx,dist) in _last50Dist.enumerate() {
            
            let tmpX = CGFloat(idx*6)
            let tmpY = CGFloat(dist*30)
            let tmp  = CGPointMake(tmpX,tmpY)
            
            points[idx] = tmp
        }
        
        
        
        //redraw spline
        _spline?.removeFromParent()
        _spline = SKShapeNode.init(splinePoints: &points, count: count)
        _spline?.strokeColor = SKColor.redColor()
        _diagram.addChild(_spline!)
    }
    
    
    
    override func mouseUp(theEvent: NSEvent) {
        _showSpline = !_showSpline
        print(theEvent.locationInNode(self))
    }
    
}





