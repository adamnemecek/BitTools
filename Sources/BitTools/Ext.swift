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

extension Sequence where Element == Bool {
    func countTrue() -> Int {
        var count = 0
        for e in self where e {
            count += 1
        }
        return count
    }
}

extension Sequence where Element: FixedWidthInteger {
    @inline(__always)
    public func allZeros() -> Bool {
        self.allSatisfy { $0 == 0}
    }
}

extension Bool {
    public func xor(_ other: Self) -> Self {
        self != other
    }

    // t, t => f
    // t, f => t
    // f, t => f
    // f, f => f
    public func nand(_ other: Self) -> Self {
        fatalError()
    }

    @inline(__always)
    func diff(_ other: Bool) -> Int {
        switch (self, other) {
        case (true, false):
            return -1
        case (false, true):
            return 1
        default:
            return 0
        }
    }
}

extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension RangeReplaceableCollection where Element == Bool {
    public init(false count: Int) {
        self.init(repeating: false, count: count)
    }

    public mutating func append(false count: Int) {
        self.append(contentsOf: repeatElement(false, count: count))
    }

    public mutating func falseAll() {
        let count = self.count
        self.removeAll(keepingCapacity: true)
        self.append(false: count)
    }
}

extension RangeReplaceableCollection where Element: FixedWidthInteger {
    public init(bitCapacity: Int) {
        self.init()
        self.reserveBitCapacity(bitCapacity)
    }

    public init(zeros count: Int) {
        self.init(repeating: 0, count: count)
    }

    public mutating func zeroAll() {
        let count = self.count
        self.removeAll(keepingCapacity: true)
        self.append(zeros: count)
    }

    @inline(__always)
    public mutating func append(zeros count: Int) {
        self.append(contentsOf: repeatElement(0, count: count))
    }

    public mutating func reserveBitCapacity(_ bitCapacity: Int) {
        let minimumCapacity = bitCapacity.blockCount(bitWidth: Element.bitWidth)
//        assert(bitCapacity % Element.bitWidth == 0)
//        let minimumCapacity = bitCapacity / Element.bitWidth
        let tail = minimumCapacity - self.count
        guard tail > 0 else { return }
        self.append(zeros: tail)
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
extension Collection where Index == Int, Element: FixedWidthInteger {
    @inline(__always)
    func contains(bit index: Index) -> Bool {
        let (offset, bit) = index.divMod(Element.bitWidth)
        return self[offset].contains(bit: Element(bit))
    }
 }
//
// extension MutableCollection where Index == Int, Element: FixedWidthInteger {
//    mutating func insert(bit index: Index) {
//        let (offset, bit) = index.divMod(Element.bitWidth)
//        self[offset].insert(bit: Element(bit))
//    }
//
//    mutating func remove(bit index: Index) {
//        let (offset, bit) = index.divMod(Element.bitWidth)
//        self[offset].remove(bit: Element(bit))
//    }
// }

extension MutableCollection where Index == Int, Element: FixedWidthInteger {
    @inline(__always)
    subscript(index: Ratio) -> Bool {
        get {
            // contains
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

    @inline(__always)
    subscript(bit index: Int) -> Bool {
        get {
            self[index.ratio(Element.bitWidth)]
        }
        set {
            self[index.ratio(Element.bitWidth)] = newValue
        }
    }
}
