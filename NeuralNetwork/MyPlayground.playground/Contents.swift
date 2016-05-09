////: Playground - noun: a place where people can play
//
//import Cocoa
//import GameKit
//
//
//
//var a1 = Array.init(count: 5, repeatedValue: 1.0)
//
//
//for i in 0..<a1.count {
//    a1[i] = Double(i)
//}
//
//extension _ArrayType where Generator.Element == Double {
//    
//    
//    var sum:Double {
//        return self.reduce(0, combine: +)
//    }
//    
//    var mean:Double {
//        return self.sum / Double(self.count)
//    }
//    
//    
//    var variance:Double {
//        let tmp = self.map({ ($0 - mean) * ($0 - mean) })
//        return tmp.sum / Double(self.count)
//    }
//    
//    var normalized:[Double] {
//        
//        let difToMeanSeq = self.map({ $0 - mean })
//        let variance_sqr = sqrt(variance)
//        
//        return difToMeanSeq.map({ $0 / variance_sqr })
//    }
//    
//
//    var distance:Double {
//        
//        
//        let quad = self.map( { ($0 + mean) * $0 } )
//        let summ = quad.sum
//        
//        return sqrt(summ)
//    }
//}
//
//
//
//
//print(a1.sum)
//
//print(a1.mean)
//
//print(a1.variance)
//
//print(a1.normalized)
//
//print(a1.distance)
//
//
//
//
//
//
//
