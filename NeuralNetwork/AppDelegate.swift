//
//  AppDelegate.swift
//  NeuralNetwork
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa
import SpriteKit



// MARK: global vars

var net_topology            = [20,20,20,20,20,20,5]
let training_loop           = 1_000_000_000

var global_learn_rate       = 0.01 as Double
var global_momentum_rate    = 0.9 as Double
var global_trainingPaused   = true
var global_Err_Sum          = 0.0
var global_Epoch            = 0 as UInt


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    
    // MARK: local vars and outlets
    
    @IBOutlet weak  var window: NSWindow!
    @IBOutlet weak  var skView:SKView!
    
    @IBOutlet weak  var startTrainingBtn:NSButton!
    @IBOutlet weak  var resetBtn:NSButton!
    
    
    @IBOutlet weak  var learnRateLabel: NSTextField!
    @IBOutlet weak  var momentumRateLabel: NSTextField!
    
    
    @IBOutlet       var txtField: NSTextView!
    @IBOutlet weak  var netToplogyField: NSTextField!
    
    
    @IBOutlet weak  var momentum_slider:NSSlider!
    @IBOutlet weak  var learnRate_slider:NSSlider!
    
    
    
    
    var _neuralNet:NeuralNet!
    var _scene:Scene!
    
    
    
    
    
    // MARK: init
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        
        newNet()
        
    }
    
    
    func newNet() {
        
        
        
        global_Err_Sum          = 0
        global_Epoch            = 0
        global_trainingPaused   = true
        
        
        
        
        _neuralNet = NeuralNet(net_topology: net_topology)
        
        
        
        //clear scene
        _scene = Scene()
        _scene.scaleMode = .ResizeFill
        skView.presentScene(_scene)
//        skView.showsFPS = true
//        skView.showsQuadCount = true
//        skView.showsNodeCount = true
//        skView.showsDrawCount = true
        
    }
    
    
    
    
    // MARK: reset net work
    
    @IBAction func resetNetwork(sender: AnyObject) {
        
        global_learn_rate       = 0.01
        global_momentum_rate    = 0.9
        
        
        learnRate_slider.doubleValue    = global_learn_rate
        momentum_slider.doubleValue     = global_momentum_rate
        
        
        learnRateLabel.stringValue      = global_learn_rate.description
        momentumRateLabel.stringValue   = global_momentum_rate.description
        
        
        _scene.removeAllActions()
        _scene.removeAllChildren()
        _scene =  nil

        
        _neuralNet = nil
        
        
        newNet()
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: interactive parameter change handler
    
    @IBAction func learRateSliderAction(slider: NSSlider) {
        global_learn_rate = slider.doubleValue
        learnRateLabel.stringValue = global_learn_rate.description
    }
    
    @IBAction func momentumRateSliderAction(slider: NSSlider) {
        global_momentum_rate = slider.doubleValue
        momentumRateLabel.stringValue = global_momentum_rate.description
    }
    
    
    ///////////////
    @IBAction func topologyDidChange(sender: NSTextField) {
        
        let token = sender.stringValue.componentsSeparatedByString(",")
        
        net_topology = token.map({ Int($0)! })
        
        //show net topology in text view
        let str = "\ncreate new net:" + net_topology.description + "\n"
        self.txtField.string?.appendContentsOf(str)
        
        //create new net
        resetNetwork("")

        
        //resign first responder
        sender.enabled = false
        NSTimer.runBlockAfterDelay(0.1) { 
            sender.enabled = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: start and stop training
    
    
    @IBAction func startTraining(btn:NSButton) {
        
        global_trainingPaused       = false
        resetBtn.enabled            = false
        startTrainingBtn.enabled    = false
        netToplogyField.enabled     = false
        
        
        let thread = NSThread(target: self, selector: #selector(training), object: nil)
        thread.threadPriority = 0.0
        thread.start()
        
    }
    
    
    
    
    
    
    func training() {
        
        for _ in 1...training_loop {

            //trainingDidEnd()
            if global_trainingPaused  {
                resetBtn.enabled            = true
                startTrainingBtn.enabled    = true
                netToplogyField.enabled     = true
                return
            }
            
            self.generateTest()
            self._neuralNet.starBP()
            
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func stopTraining(sender: AnyObject) {
        
        global_trainingPaused = true
        
        
        //trainingDidEnd()
        resetBtn.enabled            = true
        startTrainingBtn.enabled    = true
        netToplogyField.enabled     = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: info tools
    
    
    @IBAction func calcTest(_:AnyObject) {
        generateTest()
        printInfo()
    }
    
    
    
    
    
    
    @IBAction func clearTxt(_:AnyObject) {
        self.txtField.string = ""
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
    
    
    
    
    
    
    
    
    
    
    
    // MARK: utils
    
    
    
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









