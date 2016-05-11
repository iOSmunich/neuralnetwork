//
//  LGFIFO.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/10.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa

class LG_Fifo {
    
    private (set) var _fifo:[Double] = [Double]()
    private (set) var _count:Int = 0
    
    init(count:Int){
        _count = count
    }
    
    
    func push(val:Double){
        
        _fifo.append(val)
        if _fifo.count > _count {
            _fifo.removeFirst()
        }
    }
    
    var variance:Double {
        let sum = _fifo.reduce(0) { (sum, item) -> Double in
            return sum + item * item
        }
        return sqrt(sum)
    }
    
    
    var mean:Double {
        let sum = _fifo.reduce(0, combine: +)
        return sum / Double(_fifo.count)
    }
    

}
