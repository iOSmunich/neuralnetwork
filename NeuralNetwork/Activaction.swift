//
//  FastSigmoid.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/7.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa


protocol ActivationFunction {
    
    func activation(val:Double) -> Double
    func derivate(val:Double) -> Double
}



class FastSigmoid:ActivationFunction {

    
    var activationCache   = [Int:(val:Double,hit:UInt)].init(minimumCapacity: 100)
    var derivateCache     = [Int:(val:Double,hit:UInt)].init(minimumCapacity: 100)
    
    
    
    
    
    
    //sigmoid activation
    func activation(val:Double) -> Double {
        
        
        
        if val > 10 {
            return 1
        }
        
        if val < -10 {
            return 0
        }

        let key = Int(val * 100.0)
        
        if let cached = activationCache[key] {
            activationCache[key]?.hit += 1
            return cached.val
        }
        
        
        
        
        
        let newRes = 1.0 / (1.0 + exp(-val))
        
        if activationCache.count < 10000 {
            activationCache[key] = (newRes,0)
        }
            //clean up cache
        else {
            
            
            let tmp =  activationCache.sort({ (v0, v1) -> Bool in
                return v0.1.hit < v1.1.hit
            })
            
            for idx in 0..<tmp.count/4 {
                let key = tmp[idx].0
                self.activationCache.removeValueForKey(key)
            }
            
            
            //down scale hit record
            for idx in 0..<self.activationCache.count {
                self.activationCache[idx]?.hit /= 2
            }
            
            
            print("clean up activation cache")
            
            
        }
        
        return newRes
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //partial derivate of sigmoid function
    func derivate(val:Double) -> Double {
        
        
        if val > 10 || val < -10 {
            return 0.01
        }
        

        let key = Int(val * 100.0)
        if let cached = derivateCache[key] {
            derivateCache[key]?.hit += 1
            return cached.val
        }
        
        
        
        
        
        let newRes = val * (1.0 - val)
        
        
        if derivateCache.count < 1000 {
            derivateCache[key] = (newRes,0)
        }
            //clean up cache
        else {
            
            
            let tmp1 =  derivateCache.sort({ (v0, v1) -> Bool in
                return v0.1.hit < v1.1.hit
            })
            
            for idx in 0..<tmp1.count/2 {
                let key = tmp1[idx].0
                self.derivateCache.removeValueForKey(key)
            }
            
            
            for idx in 0..<self.derivateCache.count {
                self.derivateCache[idx]?.hit /= 2
            }
            
            print("clean up derivate cache")
            
            
        }
        
        return newRes
    }
    
}





class FastSigmoid2:ActivationFunction {
    
    
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


class ReLu:ActivationFunction {


    func activation(val: Double) -> Double {
        
        if val <= 0 {
            return 0
        }
        return sqrt(val)
    }
    

    func derivate(val: Double) -> Double {
        
        if val <= 0 {
            return 0
        }
        return 1
    }
}




