//
//  AppDelegate.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa
import SpriteKit


let net_topology            = [20,200,20,5]
let training_loop           = 1_000_000_000

var global_learn_rate       = 0.1 as Double
var global_trainingPaused   = true
var global_Err_Sum          = 0.0
var global_Epoch            = 0 as UInt


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    @IBOutlet weak  var learnRateLabel: NSTextField!
    @IBOutlet weak  var window: NSWindow!
    @IBOutlet       var txtField: NSTextView!
    @IBOutlet weak  var skView:SKView!
    

    
    var _neuralNet = NeuralNet(net_topology: net_topology)
    private let _scene = Scene()
    
    
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        skView.showsFPS = true
        

        _scene.scaleMode = .ResizeFill
        skView.presentScene(_scene)
        learnRateLabel.stringValue = global_learn_rate.description
    }
    
    
    @IBAction func resetNetwork(sender: AnyObject) {
        
        global_Err_Sum          = 0
        global_Epoch            = 0
        global_trainingPaused   = true
        
        _neuralNet.reset()
        _scene.reset()
    }
    
    @IBAction func learRateSliderAction(slider: NSSlider) {
        global_learn_rate = slider.doubleValue
        learnRateLabel.stringValue = global_learn_rate.description
    }
    
    
    @IBAction func stopTraining(sender: AnyObject) {

        global_trainingPaused = true
    }
    
    
    @IBAction func clearTxt(_:AnyObject) {
        self.txtField.string = ""
    }
    
    
    
    @IBOutlet weak var trainingBtn:NSButton!
    @IBAction func startTraining(_:AnyObject) {
        
        global_trainingPaused = false
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
            
            if global_trainingPaused  {
                trainingBtn.enabled = true
                return
            }
            
            self.generateTest()
            self._neuralNet.starBP()
            
            
        }
        trainingBtn.enabled = true
        
    }
    
    
    
    
    
    private func generateTest() {
        
        
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
    
    
    
    private func printInfo(){
        
        let net = _neuralNet
        
        var str = "\n"
        str += "epoch  :" + net.epoch  + "\n"
        str += "outputs:" + net.outputs + "\n"
        str += "targets:" + net.targets + "\n"
        str += "err_sum:" + net.err_sum + "\n"
        
        self.txtField.string?.appendContentsOf(str)
        self.txtField.scrollToEndOfDocument("")
        
    }
    
}









