//
//  Util.swift
//  NeuralNet
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 admin. All rights reserved.
//

import Foundation
import GameKit

////////////////////////////////////////////////////////////////////////
// MARK: print functions

func debug_print(items:Any...) {
//    Swift.print(items)
}



extension String {
    func getLocalizeWithParams(args : CVarArgType...) -> String {
        return withVaList(args) {
            NSString(format: self, locale: NSLocale.currentLocale(), arguments: $0)
            } as String
    }
}



////////////////////////////////////////////////////////////////////////
// MARK: vector functions

func - (left:[Double],right:[Double]) -> [Double] {
    
    guard left.count == right.count else {
        fatalError("err: vec0 count != vec1 count")
    }
    
    
    var res = [Double].init(count: left.count, repeatedValue: 0.0)

    for idx in 0..<res.count {
        res[idx] = left[idx] - right[idx]
    }
    

    return res
}

func - (left:[Int],right:[Int]) -> [Int] {
    
    guard left.count == right.count else {
        fatalError("err: vec0 count != vec1 count")
    }
    
    
    var res = [Int].init(count: left.count, repeatedValue: 0)
    
    for idx in 0..<res.count {
        res[idx] = left[idx] - right[idx]
    }
    
    
    return res
}



////////////////////////////////////////////////////////////////////////
// MARK: random functions
let gauss = GKGaussianDistribution(lowestValue: -100, highestValue: 100)


func randomGaussFloat()->Double{
    
    let res = gauss.nextUniform()
    return Double(res)
}



func randomPositivGaussFloat() ->Double{
    
    let res = randomGaussFloat()
    return abs(res)
}


func randomGaussFloatArray(count:Int) -> [Double] {
    var res = [Double].init(count: count, repeatedValue: 0.0)
    for idx in 0..<res.count {
        res[idx] = randomGaussFloat()
    }
    return res
}

////////////////////////////////////////////////////////////////////////
// MARK: neural functions


//sigmoid
func sigmoid(val:Double) -> Double {
    return 1.0 / (1.0 + exp(-val))
}

//partial derivate of sigmoid function
func getPartialDerivate(val:Double) -> Double {
    let f = val
    return f * (1.0 - f)
}



//calc error sum
func calcTotalError(vec0:[Double],vec1:[Double]) -> Double {
    
    guard vec0.count == vec1.count else {
        fatalError("err: vec0 count != vec1 count")
    }
    
    var sumErr = 0.0
    for idx in 0..<vec0.count {
        let partialErr = vec1[idx] - vec0[idx]
        let quadartErr = pow(partialErr, 2)
        sumErr += quadartErr
    }
    
    return sumErr * 0.5
}





func calcSum(vec0:[Double],vec1:[Double]) -> Double {
    
    guard vec0.count == vec1.count else {
        fatalError("err: vec0 count != vec1 count")
    }
    
    var sum = 0.0
    for idx in 0..<vec0.count {
        sum += vec0[idx] * vec1[idx]
    }
    return sum
}


////////////////////////////////////////////////////////
// MARK: string operators


func + (l:String,r:Int) -> String {
    return l.stringByAppendingFormat("%d", r)
}

func + (l:String,r:Double) -> String {
    return l.stringByAppendingFormat("%.4f", r)
}




func + (l:String,r:[Double]) -> String {
    
    var finalStr = l + "["
    for val in r {
        if val >= 0 {
            finalStr += " "
        }
        
        finalStr += " " + val
    }
    
    return finalStr + " ]"
}


////////////////////////////////////////////////
// MARK: numerical operators


func + (l:Double,r:Int) -> Double {
    return l + Double(r)
}

func - (l:Double,r:Int) -> Double {
    return l - Double(r)
}

func * (l:Double,r:Int) -> Double {
    return l * Double(r)
}

func / (l:Double,r:Int) -> Double {
    return l / Double(r)
}



func + (l:Int,r:Double) -> Double {
    return Double(l) + r
}
func - (l:Int,r:Double) -> Double {
    return Double(l) - r
}
func * (l:Int,r:Double) -> Double {
    return Double(l) * r
}
func / (l:Int,r:Double) -> Double {
    return Double(l) / r
}




////////////////////////////////////////////////

// MARK: timer with runBlockAfterDelay() func



extension NSTimer {
    
    
    
    static public func runBlockAfterDelay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    static public func runBlockAfterDelayWithCompletion(delay:Double, closure:()->(), complection:()->()) {
        
        
        
        let now = DISPATCH_TIME_NOW
        let nsecs = delay * Double(NSEC_PER_SEC)
        let nanos = dispatch_time(now, Int64(nsecs))
        let mainQ = dispatch_get_main_queue()
        
        let block:()->() = {
            closure()
            complection()
        }
        
        dispatch_after(nanos, mainQ, block)
        
    }
    
}


