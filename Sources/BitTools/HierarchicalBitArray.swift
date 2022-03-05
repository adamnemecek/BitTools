
///
/// this stores data
///
struct HierarchicalBitArrayMeta {
    var inner: ContiguousArray<UInt64>
}

extension HierarchicalBitArrayMeta {
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        fatalError()
    }

    
}

public struct HierarchicalBitArray {
    var meta: HierarchicalBitArrayMeta
    var inner: BitArray
}
