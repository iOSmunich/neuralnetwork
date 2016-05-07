//
//  NeuralNet.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation






////////////////////////////////////////////////////////////
class NeuralNet {
    
    var layers:[Layer] = []
    
    var inputLayer:Layer { return layers.first! }
    var outputLayer:Layer { return layers.last! }
    
    let fastSigmoid:FastSigmoid = FastSigmoid()

    
    private (set) var  inputs:[Double]!
    private (set) var outputs:[Double]!
    private (set) var targets:[Double]!//use setOutputs!
    
    private (set) var err_sum: Double!//use setOutputs!
    private (set) var epoche:Int = 0
    
    
    
    ////////////////////////////////////////////////////////////
    
    init (net_topology:[Int]) {
        
        //create layer
        for count in net_topology {
            layers.append(Layer(count: count))
        }
        
        
        //assign a index to each layer and its neurons
        for (layerIdx,ll) in layers.enumerate() {
            
            ll.index = layerIdx
            ll.layers = layers
            
            for (nnIndex,nn) in ll.neurons.enumerate() {
                nn.layerIndex = layerIdx
                nn.index = nnIndex
                nn.layer = ll
                
                nn.fastSigmoid = self.fastSigmoid
            }
        }
        
    }
    
    
    ////////////////////////////////////////////////////////////
    
    
    func setInputs(inputs:[Double]) {
        self.inputs = inputs
        inputLayer.setInputs(self.inputs)
        setOutputs()
    }
    
    func setOutputs() {
        
        self.outputs = outputLayer.outputs
        
    }
    
    
    func setTargets(targets:[Double]) {
        
        self.targets = targets
        
        err_sum = calcTotalError(targets, vec1: outputs)
          
    }
    
    
    
    func starBP() {
        if self.targets == nil {
            return
        }
        
        epoche += 1

        //set target for output layer
        for idx in 0..<targets.count {
            let nn = outputLayer.neurons[idx]
            nn.setTarget(targets[idx])
        }
        
        layers.last?.updateWeights()
        
    }
    

}






