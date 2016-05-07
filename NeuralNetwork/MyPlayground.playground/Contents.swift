//: Playground - noun: a place where people can play

import Cocoa
import GameKit

let distribution = GKRandomDistribution(lowestValue: -10, highestValue: 10)


for _ in 0...10 {
print(distribution.nextUniform())
}



