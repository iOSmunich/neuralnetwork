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
    
    
    var activationFunc:ActivationFunction!
    var old_delta:[Double]!
    
    
    
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
        
        weights     = Array.init(count: self.inputs.count, repeatedValue: 0.0)
        old_delta   = [Double].init(count: weights.count+1, repeatedValue: 0)
        self.bias   = randomDouble()
        
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
            
            let new_delta   =   -1 * learn_rate * gradient * inputs[idx] + 0.9*old_delta[idx]
            weights[idx]    +=  new_delta
            old_delta[idx]  =   new_delta
        }
        
        //update bias
        
        
        let new_delta = -1 * learn_rate * gradient + 0.9*old_delta.last!
        bias += new_delta
        old_delta[old_delta.count-1] = new_delta
        
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
    
    
    
    //sigmoid activation
    func activation(val:Double) -> Double {
        return activationFunc.activation(val)
    }
    
    //partial derivate of sigmoid function
    func derivate(f:Double) -> Double {
        return activationFunc.derivate(f)
    }
    
}





