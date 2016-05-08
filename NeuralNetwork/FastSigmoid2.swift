//
//  FastSigmoid.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa

class FastSigmoid2 {
    
    
    var _activatCache:NSCache = NSCache()
    var _derivatCache:NSCache = NSCache()
    
    
    
    init() {
        
        _activatCache.countLimit = 10000
        _derivatCache.countLimit = 2000
    }
    
    
    
    
    
    
    //sigmoid activation
    func activation(val:Double) -> Double {
        
        if val > 10 {
            return 1.00
        }
        
        if val < -10 {
            return -0.00
        }
        
        
        
        let key = Int(val * 100)
        
        if let record = _activatCache.objectForKey(key) {
            return record as! Double
        }
        
        
        let newRes = 1.0 / (1.0 + exp(-val))
        _activatCache.setObject(newRes, forKey: key)
        
        return newRes
    }
    
    
    
    
    
    //partial derivate of sigmoid function
    func derivate(val:Double) -> Double {
        
        if val > 20 || val < -20 {
            return 0.00
        }
        
        let key = Int(val * 100)
        
        if let record = _derivatCache.objectForKey(key) {
            return record as! Double
        }
        
        
        let newRes = val * (1.0 - val)
        _derivatCache.setObject(newRes, forKey: key)
        
        return newRes
        
    }
    
}
