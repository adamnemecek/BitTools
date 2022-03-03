
extension Collection {

//    var isSome: Bool {
//        !self.isEmpty
//    }

//    @inline(__always)
//    public func or(_ other: Self) -> Self {
//        if self.isEmpty {
//            return other
//        }
//        return self
//    }

    @inline(__always)
    static func ??(lhs: Self, rhs: Self) -> Self {
        if lhs.isEmpty {
            return rhs
        }
        return lhs
    }
}




extension RangeReplaceableCollection where Element: FixedWidthInteger {
    init(bitCapacity: Int) {
        self.init()
        self.reserveBitCapacity(bitCapacity)
    }

    public mutating func reserveBitCapacity(_ bitCapacity: Int) {
        assert(bitCapacity % Element.bitWidth == 0)
        let minimumCapacity = bitCapacity / Element.bitWidth
        let tail = minimumCapacity - self.count
        guard tail > 0 else { return }
        self.append(contentsOf: repeatElement(0, count: tail))
    }
}

/// goes over blocks and sums the population
extension Sequence where Element: FixedWidthInteger {
    public var nonzeroBitCount: Int {
        self.reduce(0) { $0 + $1.nonzeroBitCount }
//        var count = 0
//        for e in self {
//            count += e.nonzeroBitCount
//        }
//        return count
    }
}
//extension Collection where Index == Int, Element: FixedWidthInteger {
//    func contains(bit index: Index) -> Bool {
//        let (offset, bit) = index.divMod(Element.bitWidth)
//        return self[offset].contains(bit: Element(bit))
//    }
// }
//
//extension MutableCollection where Index == Int, Element: FixedWidthInteger {
//    mutating func insert(bit index: Index) {
//        let (offset, bit) = index.divMod(Element.bitWidth)
//        self[offset].insert(bit: Element(bit))
//    }
//
//    mutating func remove(bit index: Index) {
//        let (offset, bit) = index.divMod(Element.bitWidth)
//        self[offset].remove(bit: Element(bit))
//    }
//}

extension MutableCollection where Index == Int, Element: FixedWidthInteger {
    @inline(__always)
    public subscript(index: Ratio) -> Bool {
        get {
            self[index.quot].contains(bit: Element(index.rem))
        }
        set {
            if newValue {
                // insert
                self[index.quot].insert(bit: Element(index.rem))
            } else {
                // remove
                self[index.quot].remove(bit: Element(index.rem))
            }
        }
    }
}
