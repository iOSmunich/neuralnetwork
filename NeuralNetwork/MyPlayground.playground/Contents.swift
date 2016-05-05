//: Playground - noun: a place where people can play

import Cocoa



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








