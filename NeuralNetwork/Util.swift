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
    
    var res = [Double](count: left.count, repeatedValue: 0.0)
    
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

extension _ArrayType where Generator.Element == Double {
    
    
    var _sum:Double {
        return self.reduce(0, combine: +)
    }
    
    var mean:Double {
        return self._sum / Double(self.count)
    }
    
    var DTM:[Double] {
        return self.map({$0 - mean})
    }
    
    var variance:Double {
        let tmp = self.map({ ($0 - mean) * ($0 - mean) })
        return tmp._sum / Double(self.count)
    }
    
    
    var normalized:[Double] {
        
        let difToMeanSeq = self.map({ $0 - mean })
        let variance_sqr = sqrt(variance)
        
        return difToMeanSeq.map({ $0 / variance_sqr })
    }
    
    var dist:Double {
        let quadSum = self.reduce(0) { (qsum, itemVal) -> Double in
            return qsum + itemVal * itemVal
        }
        
        if quadSum < 0.0001 {
            
            return 0.0
        }

        return sqrt(quadSum)
    }
    
    var normal:[Double] {
        return self.map({ $0 / dist })
    }

    
    
    func getSlices(maxLen:Int) -> [[Double]] {
        
        if maxLen < 1 || self.count < 1 {
            return [[]]
        }
        
        let slice_num = self.count / maxLen
        
        if slice_num < 1 {
            return [[Double](self)]
        }
        
        
        
        let slice_len = maxLen
        let restLen = self.count%slice_num

        let tmp = [Double].init(count: slice_len, repeatedValue: 0)
        var res = [[Double]].init(count: slice_num, repeatedValue: tmp)
        

        for i in 0..<slice_num {
            for j in 0..<slice_len {
                let offset = i*slice_len + j
                res[i][j] = self[offset]
            }
        }
        
        if restLen == 0 {
            return res
        }
        
        
        
        let start_rest = self.count - restLen
        var rest = [Double]()
        for i in start_rest..<self.count {
            rest.append(self[i])
        }
        res.append(rest)
        
        return res
    }

}



////////////////////////////////////////////////////////////////////////
// MARK: random functions


func randomGaussFloat()->Double{
    let gaussDistribution = GKGaussianDistribution(lowestValue: -100, highestValue: 100)
    let res = gaussDistribution.nextUniform()
    return Double(res)
}

func randomDouble() -> Double {
    let distributionMin1Max1 = GKRandomDistribution(lowestValue: -100, highestValue: 100)
    return Double(distributionMin1Max1.nextUniform())
}

func randomPositivDouble() -> Double {
    let distributionMin0Max1 = GKRandomDistribution(lowestValue: 0, highestValue: 100)
    return Double(distributionMin0Max1.nextUniform())
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
    
    let difVec = vec0 - vec1
    
    return 0.5 * difVec.reduce(0.0, combine: { (quadSum, itemVal) -> Double in
        return quadSum + itemVal * itemVal
    })
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



extension Int {
    var doubleValue:Double {
        return Double(self)
    }
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



func getSlices(maxLen:Int,selfList:[Double]) -> [[Double]] {
    
    let slice_num = selfList.count / maxLen
    let slice_len = maxLen
    let restLen = selfList.count%slice_num
    
    let tmp = [Double].init(count: slice_len, repeatedValue: 0)
    var res = [[Double]].init(count: slice_num, repeatedValue: tmp)
    
    
    for i in 0..<slice_num {
        for j in 0..<slice_len {
            let offset = i*slice_len + j
            res[i][j] = selfList[offset]
        }
    }
    
    if restLen == 0 {
        return res
    }
    
    
    
    let start_rest = selfList.count - restLen
    var rest = [Double]()
    for i in start_rest..<selfList.count {
        rest.append(selfList[i])
    }
    res.append(rest)
    
    return res
}

