//
//  SportTimer.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa

class SportTimer {
    
    private var _timer:NSTimer!
    private var _count = 0 as Double
    private var _paused = true
    
    var elapsedTime:Double {
        return _count
    }
    
    private func createTimer(){
        _timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(doCount), userInfo: nil, repeats: true)
        _timer.fire()
    }

    
    @objc private func doCount(){
        if !_paused {
            _count += 0.1
        }
    }
    
    func start(){
        _paused = false
        
        if _timer == nil {
            createTimer()
        }
    }
    
    func pause(){
        _paused = true
    }
    
    func reset(){
        
        _paused = true
        _count  = 0
        
        if _timer == nil {
            return
        }
        
        if _timer.valid {
            _timer.invalidate()
        }
        _timer  = nil
    }
    
}

