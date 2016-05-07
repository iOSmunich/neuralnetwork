//
//  AppDelegate.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa


let net_topology = [8,5]
let learn_rate = 0.3
let training_loop = 10000
var _stopTraining = true



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
    
    
    @IBOutlet weak var trainingBtn:NSButton!
    @IBAction func startTraining(_:AnyObject) {
        
        performSelectorInBackground(#selector(training), withObject: nil)
        
    }
    
    
    func training() {
        
        _stopTraining = false
        
        trainingBtn.enabled = false
        for _ in 1...training_loop {
            
            if _stopTraining  {
                trainingBtn.enabled = true
                return
            }
            
            
            self.generateTest()
            self._neuralNet.starBP()
            
        }
        
        let net = self._neuralNet
        print("\nepoche:"+net.epoche)
        print("outputs:"+net.outputs)
        print("targets:"+net.targets)
        print("err_sum:"+net.err_sum)
        
        trainingBtn.enabled = true
        
    }
    
    @IBAction func calcTest(_:AnyObject) {
        generateTest()
        
        let net = _neuralNet
        
        print("\nepoche:"+net.epoche)
        print("outputs:"+net.outputs)
        print("targets:"+net.targets)
        print("err_sum:"+net.err_sum)
        
    }
    
    
    func generateTest() {
        
        
        let x1 = random() % 2
        let x2 = random() % 2
        
        let y1 = x1 ^ x2 // xor
        let y2 = x1 & x2 // and
        let y3 = x1 | x2 // or
        let y4 = (x1 + x2)%2 //sum
        
        let y5 = x1 > 0 ? 0.0 : 1.0 //not
        
        
        
        let _inputs = [x1.doubleValue,x2.doubleValue]
        let _target = [y1.doubleValue,y2.doubleValue,y3.doubleValue,y4.doubleValue,y5]
        
        _neuralNet.setInputs (_inputs)
        _neuralNet.setTargets(_target)
    }
    
    @IBAction func stopTraining(sender: AnyObject) {
        _stopTraining = true
    }
}








