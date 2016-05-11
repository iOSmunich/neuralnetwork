import Cocoa



var a = [Double].init(count: 10, repeatedValue: 0)

for n in 0..<a.count {
    a[n] = Double(n) + 0.1
}


print(a)





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


let b = getSlices(2, selfList: a)

print(b)



