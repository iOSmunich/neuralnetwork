//
//  Neuron.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation


class Neuron {
    
    
    //////////////////////////////////
    // variables
    
    var layer:Layer!
    var layerIndex  = -1
    var index       = -1
    
    
    
    
    
    
    private (set) var inputs:[Double]!
    private (set) var output = 0.0 //use setOutput!
    
    private (set) var weights:[Double]!
    private (set) var bias:Double = 0.0
    private (set) var net_sum = 0.0
    
    
    
    private (set) var target:Double!//only used in output neuron
    private (set) var gradient:Double!
    
    
    
    
    //////////////////////////////////
    // set inputs outputs
    func setInputs(inputs:[Double]) {
        self.inputs = inputs
        syncWeights()
        
        
        //calc sum and activation
        net_sum = calcSum(inputs, vec1: weights) + bias
        let _output = sigmoid(net_sum)
        setOutput(_output)
    }
    
    
    
    
    
    func setOutput(val:Double) {
        output = val
        
        //update layers outputs
        layer.setOutputAtIndex(index, newValue: output)
    }
    
    
    //////////////////////////////////
    // init weights if not set
    func syncWeights() {
        if weights != nil { return }
        
        weights = Array.init(count: self.inputs.count, repeatedValue: 0.0)
        
        for idx in 0..<weights.count {
            weights[idx] = randomGaussFloat()
        }
        
        debug_print("l",layerIndex,"n",index," weights:"+weights,"bias:"+bias)
    }
    
    
    //////////////////////////////////
    // update gradient    
    func setTarget(tar:Double) {
        target = tar
    }
    
    
    //delta weight = -a * w_grad * net_grad * out_grad
    func updateWeights() {
        
        //update net2out_grad
        gradient = out2target_grad() * output * ( 1 - output)
        
        
        //update each weight
        for idx in 0..<weights.count {
        
            let weight2target_grad  = gradient * inputs[idx]
            let weight_delta        = learn_rate  * weight2target_grad
            
            weights[idx] -= weight_delta
        }
        
        //update bias
        bias -= learn_rate * gradient
    }
    
    
    
    //////////////////////////////////
    // output val to target val gradient
    
    func out2target_grad() -> Double {
        
        
        //if output neuron
        if isOutputNeuron() {
            return (output - target)
        }
        
        
        //else hidden neuron
        var tmp_sum = 0.0
        for nn in outputNeurons {
            
            tmp_sum += nn.gradient * nn.weights[self.index]
        }
        
        return tmp_sum
    }
    
    
    func isOutputNeuron() -> Bool {
        
        if layer.hasNextLayer {
            return false
        }
        
        return true
    }
    
    
    var outputNeurons:[Neuron]  {
        return  layer.nextLayer!.neurons
    }
    
    
}









