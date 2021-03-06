// struct BitStatistics {
//    let nonzeroBitCount: Int
//    let startBit: Int
//    let endBit: Int
// }

func countBits(
    _ a: UnsafePointer<UInt64>,
    count: Int
) -> Int {
    guard count != 0 else { return 0 }

    var i = a
    var nonzeroBitCount = 0

    for _ in 0 ..< count {
        nonzeroBitCount += i.pointee.nonzeroBitCount
        i = i.successor()
    }
    return nonzeroBitCount
}

func allZero(
    _ ptr: UnsafePointer<UInt64>,
    count: Int
) -> Bool {
    guard count != 0 else { return true }

    var i = ptr
    for _ in 0 ..< count {
        if i.pointee != 0 {
            return false
        }
        i = i.successor()
    }

    return true
}

func countBits(
    _ a: UnsafePointer<UInt64>,
    _ b: UnsafePointer<UInt64>,
    count: Int,
    op: (UInt64, UInt64) -> UInt64
) -> Int {
    guard count != 0 else { return 0 }

    var i = a
    var j = b

    var nonzeroBitCount = 0
    for _ in 0 ..< count {
        nonzeroBitCount += op(i.pointee, j.pointee).nonzeroBitCount
        i = i.successor()
        j = j.successor()
    }
    return nonzeroBitCount
}

func countUnion(
    _ a: UnsafeBufferPointer<UInt64>,
    _ b: UnsafeBufferPointer<UInt64>
) -> Int {

    guard var i = a.baseAddress,
          var j = b.baseAddress else { return 0 }

    var nonzeroBitCount = 0

    let count = Swift.min(a.count, b.count)

    for _ in 0 ..< count {
        nonzeroBitCount += (i.pointee & j.pointee).nonzeroBitCount

        i = i.successor()
        j = j.successor()
    }

    return nonzeroBitCount
    + countBits(i, count: a.count - count)
    + countBits(j, count: b.count - count)
}

func pointersEqual(
    _ a: UnsafeBufferPointer<UInt64>,
    _ b: UnsafeBufferPointer<UInt64>
) -> Bool {
    fatalError()
}

// func countUnion1(
//    _ a: UnsafeBufferPointer<UInt64>,
//    _ b: UnsafeBufferPointer<UInt64>
// ) -> Int {
//
//    guard var i = a.baseAddress,
//          var j = b.baseAddress else { return 0 }
//
//    var nonzeroBitCount = 0
//
//    let count = Swift.min(a.count, b.count)
//
//
//    for _ in 0 ..< count {
//        nonzeroBitCount += (i.pointee & j.pointee).nonzeroBitCount
//
//        i = i.successor()
//        j = j.successor()
//    }
//
//    return nonzeroBitCount
//    + countBits(i, count: a.count - count)
//    + countBits(j, count: b.count - count)
// }

func countIntersection(
    //
) -> Int {
    fatalError()
}

func countSubtract(
    //
) -> Int {
    fatalError()
}

func countSymmetricDifference(
    //
) -> Int {
    fatalError()
}
