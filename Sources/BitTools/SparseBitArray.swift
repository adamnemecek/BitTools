
import Foundation

public func koremetalbundle()  {
    for b in Bundle.allFrameworks {
        print(b)
    }
}
///
/// this stores data
///
struct SparseBitArrayMeta {
    var inner: ContiguousArray<UInt64>
}

extension SparseBitArrayMeta {
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        fatalError()
    }

    
}

public struct SparseBitArray {
    var meta: SparseBitArrayMeta
    var inner: BitArray
}

extension SparseBitArray {
    var count: Int {
        self.inner.count
    }
}

//extension SparseBitArray: Sequence {
//    public func makeIterator() -> AnyIterator<Int> {

//        fatalError()
//    }
//}

//
//struct SparseBitArrayIterator {
//
//}


