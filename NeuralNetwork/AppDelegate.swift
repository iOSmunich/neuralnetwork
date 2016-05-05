//
//  AppDelegate.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa


let net_topology = [4,2]
let learn_rate = 0.3



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    var _neuralNet = NeuralNet(net_topology: net_topology)
    
    
    
    @IBAction func showDebugInfo(_:AnyObject) {
        
        for ll in _neuralNet.layers {

            print("\n")
            for nn in ll.neurons {
                print("l:",nn.layerIndex,"n",nn.index," weights:"+nn.weights+" "+nn.bias)
            }
            
        }
    
    }

    @IBAction func startTraining(_:AnyObject) {
        
        
        for _ in 1...500 {
            
            
            generateTest()
            _neuralNet.starBP()

        }
        
        let net = _neuralNet
        
        print("\nepoche:"+net.epoche)
        print("outputs:"+net.outputs)
        print("targets:"+net.targets)
        print("err_sum:"+net.err_sum)
        
    }
    
    @IBAction func calcTest(_:AnyObject) {
        generateTest()
    }
    
    
    func generateTest() {
        
        let x1 = randomGaussFloat()>0 ? 1:0
        let x2 = randomGaussFloat()>0 ? 1:0
        let y = x1 ^ x2
        
        
        _neuralNet.setInputs ([Double(x1),Double(x2)])
        _neuralNet.setTargets([0,Double(y)])
    }
    
}

