//
//  Layer.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation

class Layer {
    
    
    
    //////////////////////////////////
    // variables
    
    var index = -1
    var layers:[Layer]!
    
    
    
    
    
    private (set) var neurons:[Neuron] = []
    private (set) var inputs:[Double]!
    private (set) var outputs:[Double]! = []
    
    
    
    
    
    
    //////////////////////////////////
    // init
    init(count:Int) {
        
        //create outpus array
        outputs = [Double].init(count: count, repeatedValue: 0.0)
        
        //create neurons
        for _ in 0..<count {
            neurons.append(Neuron())
        }
        
    }
    
    
    
    
    
    
    
    //////////////////////////////////
    // set inputs outputs
    func setInputs(inputs:[Double]) {
        self.inputs = inputs
        
        //calc
        setNeuronsInputs()
        
        if hasNextLayer {
            nextLayer!.setInputs(self.outputs)
        }
        
    }
    
    
    func setOutputAtIndex(idx:Int, newValue:Double) {
        outputs[idx] = newValue
    }
    
    
    func setNeuronsInputs() {
        for nn in neurons {
            nn.setInputs(inputs)
        }
    }
    

    
    ////////////////////////////////////
    // update weights of nodes
    
    func updateWeights(){
        
        for nn in neurons {
            nn.updateWeights()
        }
        
        
        if hasPreLayer {
            preLayer?.updateWeights()
        }        
    }
    
    
    
    ////////////////////////////////////
    // tools
    
    var nextLayer:Layer? {
        return layers[index+1]
    }
    
    var preLayer:Layer? {
        return layers[index-1]
    }
    
    var hasNextLayer:Bool {
        return self.index < layers.count-1
    }
    
    var hasPreLayer:Bool {
        return self.index > 0
    }
    
    
    
    
}











