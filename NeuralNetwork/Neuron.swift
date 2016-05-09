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
    var layerIndex  = -1 as Int
    var index       = -1 as Int
    
    
    
    
    
    
    private (set) var inputs:[Double]!
    private (set) var output:Double = 0.0 //use setOutput!
    
    private (set) var weights:[Double]!
    private (set) var bias:Double = 0.0
    private (set) var net_sum:Double = 0.0
    
    
    
    private (set) var target:Double!//only used in output neuron
    private (set) var gradient:Double!
    
    
    
    
    //////////////////////////////////
    // set inputs outputs
    func setInputs(inputs:[Double]) {
        
        self.inputs = inputs
        syncWeights()
        
        
        //calc sum and activation
        net_sum = calcSum(inputs, vec1: weights) + bias
        let _output = activation(net_sum)
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
            weights[idx] = randomDouble()
        }
        
    }
    
    
    //////////////////////////////////
    // update gradient
    func setTarget(tar:Double) {
        target = tar
    }
    
    
    //delta weight = -a * w_grad * net_grad * out_grad
    func updateWeights() {
        
        
        //update net2out_grad
        gradient = out2target_grad() * derivate(output)
        
        
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
        if isOutputNeuron {
            return (output - target)
        }
        
        
        //else hidden neuron
        return outputNeurons.reduce(0.0, combine: { (sum, node) -> Double in
            return sum + node.gradient * node.weights[self.index]
        })
        
    }
    
    
    
    var isOutputNeuron:Bool     { return !layer.hasNextLayer }
    var outputNeurons:[Neuron]  { return  layer.nextLayer!.neurons }
    var fastSigmoid:FastSigmoid!
    
    
    //sigmoid activation
    func activation(val:Double) -> Double {
        return fastSigmoid.activation(val)
    }
    
    //partial derivate of sigmoid function
    func derivate(f:Double) -> Double {
        return fastSigmoid.derivate(f)
    }
    
}

////sigmoid activation
//func activation(val:Double) -> Double {
//    return 1.0 / (1.0 + exp(-val))
//    
//}
//
//
////partial derivate of sigmoid function
//func derivate(f:Double) -> Double {
//    return f * (1.0 - f)
//}




