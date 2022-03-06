
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



