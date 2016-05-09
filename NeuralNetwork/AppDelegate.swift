//
//  AppDelegate.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa


let net_topology    = [5,5,5]
let learn_rate      = 0.1
let training_loop   = 5_000_000
var _stopTraining   = true



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet  var txtField: NSTextView!
    
    var _neuralNet = NeuralNet(net_topology: net_topology)
    
    
    @IBAction func stopTraining(sender: AnyObject) {
        _stopTraining = true
    }
    
    
    @IBAction func clearTxt(_:AnyObject) {
        self.txtField.string = ""
    }
    
    
    
    @IBOutlet weak var trainingBtn:NSButton!
    @IBAction func startTraining(_:AnyObject) {
        
        _stopTraining = false
        trainingBtn.enabled = false
        
        
        let thread = NSThread(target: self, selector: #selector(training), object: nil)
        thread.threadPriority = 0.0
        thread.start()
        
        
    }
    
    @IBAction func showDebugInfo(_:AnyObject) {
        
        for ll in _neuralNet.layers {
            
            var str = "\n"
            for nn in ll.neurons {
                str += "l:"+nn.layerIndex + " n"+nn.index + " weights:"+nn.weights + " "+nn.bias + "\n"
            }
            self.txtField.string?.appendContentsOf(str + "\n")
            
            self.txtField.scrollToEndOfDocument("")
            
        }
    }
    
    
    @IBAction func calcTest(_:AnyObject) {
        generateTest()
        printInfo()
    }
    
    
    
    
    func training() {
        
        for _ in 1...training_loop {
            
            if _stopTraining  {
                trainingBtn.enabled = true
                return
            }
            
            self.generateTest()
            self._neuralNet.starBP()
            
        }
        trainingBtn.enabled = true
        
    }
    
    
    
    
    
    
    
    func generateTest() {
        
        
        let x1 = random() % 2
        let x2 = random() % 2
        
        let y1 = x1 ^ x2 // xor
        let y2 = x1 & x2 // and
        let y3 = x1 | x2 // or
        let y4 = (x1 + x2)%2 //sum
        
        let y5 = x1 > 0 ? 0.0 : 1.0 //not
        
        
        
        
        var _inputs = [x1.doubleValue,x2.doubleValue]
        var _target = [y1.doubleValue,y2.doubleValue,y3.doubleValue,y4.doubleValue,y5]
        
        
//        _inputs = _inputs.map({
//            return $0 > 0 ? 0.5 : 0.0
//        })
//        
//        _target = _target.map( {
//            return $0 > 0 ? 0.5 : 0.0
//        })
        
        _neuralNet.setInputs (_inputs)
        _neuralNet.setTargets(_target)
    }
    
    
    
    
    
    func printInfo(){
        
        let net = _neuralNet
        
        var str = "\n"
        str += "epoche:"  + net.epoche  + "\n"
        str += "outputs:" + net.outputs + "\n"
        str += "targets:" + net.targets + "\n"
        str += "err_sum:" + net.err_sum + "\n"
        
        self.txtField.string?.appendContentsOf(str)
        self.txtField.scrollToEndOfDocument("")
        
    }
    
}









