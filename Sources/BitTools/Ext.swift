
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
    public static func ??(lhs: Self, rhs: Self) -> Self {
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

extension MutableCollection where Index == Int, Element == UInt64 {
    @inline(__always)
    public subscript(index: Ratio) -> Bool {
        get {
            self[index.quot].contains(bit: UInt64(index.rem))
        }
        set {
            if newValue {
                // insert
//                self[index.quot] |= (1 << index.rem)
                self[index.quot].insert(bit: UInt64(index.rem))
            } else {
                // remove
//                self[index.quot] &= ~(1 << index.rem)
                self[index.quot].remove(bit: UInt64(index.rem))
            }
        }
    }
}
