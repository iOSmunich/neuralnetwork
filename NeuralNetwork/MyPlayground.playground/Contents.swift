//: Playground - noun: a place where people can play

import Cocoa
import GameKit

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

func activation(val:Double) -> Double {
    return 1.0 / (1.0 + exp(-val))
    //        return max(0.0, val) // relu
}

//partial derivate of sigmoid function
func derivate(f:Double) -> Double {
    return f * (1.0 - f)
    
    //    if f > 0.0 {
    //        return 1.0
    //    }
    //    return 0.0
}




var inputs = [Double].init(count: 20, repeatedValue: 0.0)

for i in 0..<inputs.count {
    
    let dist = GKRandomDistribution(lowestValue: -1000, highestValue: 1000)
    inputs[i] = Double(dist.nextUniform())
    
}

inputs = inputs.sort()

let outputs = inputs.map { (item) -> Double in
    return derivate(item)
}

print(""+inputs)
print(""+outputs)






