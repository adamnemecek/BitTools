
protocol DivMod {
    func divMod(_ other: Self) -> (Self, Self)
}

extension RangeReplaceableCollection where Element: FixedWidthInteger {
    init(bitCapacity: Int) {
        assert(bitCapacity % Element.bitWidth == 0)
        let blocks = bitCapacity / Element.bitWidth
        self.init()
        self.append(contentsOf: repeatElement(0, count: blocks))
    }
}

public struct Ratio: Equatable {
    let quot: Int
    let rem: Int
}

extension Int {
    public func ratio(_ other: Int) -> Ratio {
        let (quot, rem) = self.divMod(other)
        return Ratio(quot: quot, rem: rem)
    }
}

extension Int: DivMod {
    func divMod(_ other: Self) -> (Self, Self) {
        self.quotientAndRemainder(dividingBy: other)
    }
}

// extension Collection where Index == Int, Element == UInt64 {
//    func contains(at index: Index) -> Bool {
//        let (offset, bit) = index.divMod(Element.bitWidth)
//        return self[offset].isBitSet(at: bit)
//    }
// }

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

public struct BitArray {
    public typealias Element = Int
    typealias Block = UInt64

    public private(set) var count: Int
    private var inner: ContiguousArray<UInt64>

    ///
    /// capacity in blocks
    ///
    public var capacity: Int {
        self.inner.capacity
    }

    public var bitCapacity: Int {
        self.capacity * Block.bitWidth
    }

    public var isEmpty: Bool {
        self.count == 0
    }
}

// extension BitVector: SetAlgebra {
//
// }

extension BitArray: Sequence {

//    public func makeIterator() -> AnyIterator<Int> {
//        var currentBlock: UInt64 = 0
//        var blockIndex = 0
//        var count = 0
//        return AnyIterator {
//            while true {
//                guard count < self.count else { return nil }
//                while currentBlock.leadingZeroBitCount != 0 {
//
//                    count += 1
//                }
//            }
//        }
//    }

    public func makeIterator() -> AnyIterator<Int> {
//        var i = self.inner.makeIterator()
        let nonzeroBitCount = self.count
        var count = 0
        let blockCount = self.inner.count
        var blockIndex = 0
        var bitIterator = BitSequence(self.inner[blockIndex]).makeIterator()
        return AnyIterator {
            while count < nonzeroBitCount {
                if let next = bitIterator.next() {
                    count += 1
                    return blockIndex * Block.bitWidth + Int(next)
                } else {
                    guard blockIndex + 1 < blockCount else { return nil }
                    blockIndex += 1
                    bitIterator = BitSequence(self.inner[blockIndex]).makeIterator()
                }
            }
            return nil
        }
    }

//    public func makeIterator1() -> AnyIterator<Int> {
////        var i = self.inner.makeIterator()
//        let nonzeroBitCount = self.count
//        var count = 0
////        let blockCount = self.inner.count
////        var blockIndex = 0
////        var bitIterator = BitSequence(self.inner[blockIndex]).makeIterator()
//        var i = self.inner.enumerated().makeIterator()
//        return AnyIterator {
//            while count < nonzeroBitCount {
//                if let next = bitIterator.next() {
//                    count += 1
//                    return blockIndex * Block.bitWidth + Int(next)
//                } else {
//                    guard blockIndex + 1 < blockCount else { return nil }
//                    blockIndex += 1
//                    bitIterator = BitSequence(self.inner[blockIndex]).makeIterator()
//                }
//            }
//            return nil
//        }
//    }

    public var underestimatedCount: Int {
        self.count
    }
}

extension BitArray {

}

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

extension BitArray: SetAlgebra {

    public init() {
        self.count = 0
        self.inner = []
    }

    init(
        inner: ContiguousArray<UInt64>,
        count: Int
    ) {
        self.inner = inner
        self.count = count
    }

    public init(capacity: Int) {
        self.count = 0
        self.inner = ContiguousArray(repeating: 0, count: capacity)
    }

    public init(bitCapacity: Int) {
        self.count = 0
        self.inner = []
        self.reserveBitCapacity(bitCapacity)
    }

    public mutating func updateCount() {
        self.count = self.nonzeroBitCount
    }

    ///
    /// this is in blocks
    ///
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        self.inner.append(contentsOf: repeatElement(0, count: count))
    }

    mutating func reserveCapacity(for value: Element) {
        let a = value.blockCount(bitWidth: Block.bitWidth)
        self.reserveCapacity(a)
    }

    mutating func reserveBitCapacity(_ bitCapacity: Int) {
        self.reserveCapacity(bitCapacity.roundUp(to: Block.bitWidth))
    }

    public __consuming func union(
        _ other: __owned Self
    ) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        var inner = ContiguousArray<UInt64>(repeating: 0, count: maxCapacity)

        var count = 0
        for i in 0..<minCapacity {
            let new = self.inner[i] | other.inner[i]
            count += new.nonzeroBitCount
            inner[i] = new
        }

        let tail = self.inner[minCapacity...] ?? other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            inner[i] = new
            count += new.nonzeroBitCount
        }

        return Self(
            inner: inner,
            count: count
        )
    }

    public mutating func formUnion(
        _ other: __owned Self
    ) {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        self.reserveCapacity(other.capacity)

        var count = 0
        for i in 0..<minCapacity {
            let new = self.inner[i] | other.inner[i]
            count += new.nonzeroBitCount
            self.inner[i] = new
        }

        let tail = other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            self.inner[i] = new
            count += new.nonzeroBitCount
        }

        self.count = count
    }

    public __consuming func intersection(
        _ other: Self
    ) -> Self {

        let capacity = Swift.min(self.bitCapacity, other.bitCapacity)

        assert(capacity % Block.bitWidth == 0)

        var inner = ContiguousArray<UInt64>(repeating: 0, count: capacity)

//        let startIndex = Swift.max(self.startIndex, other.startIndex)
//        let endIndex = Swift.min(self.endIndex, other.endIndex)

        var count = 0
        for i in 0..<capacity {
            let new = self.inner[i] | other.inner[i]
            count += new.nonzeroBitCount
            inner[i] = new
        }

        if self.capacity < other.capacity {

        } else {

        }
        fatalError()
//
//        return Self(
//            inner: inner
////            count: count
////            startIndex: startIndex
////            endIndex: endIndex
//        )
    }

    func ratio(for member: Int) -> Ratio {
        member.ratio(Block.bitWidth)
    }

    public __consuming func symmetricDifference(
        _ other: __owned Self
    ) -> Self {
        fatalError()
    }

    public mutating func insert(
        _ newMember: __owned Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        self.reserveCapacity(for: newMember)

        let ratio = self.ratio(for: newMember)
        let contains = self.inner[ratio]
        guard !contains else { return (false, newMember) }
        self.inner[ratio] = true
        self.count += 1
        return (true, newMember)

    }

    public func contains(
        _ member: Element
    ) -> Bool {
        guard member < self.bitCapacity else { return false }
        let ratio = self.ratio(for: member)
        return self.inner[ratio]
    }

    public mutating func remove(
        _ member: Element
    ) -> Element? {
        let ratio = self.ratio(for: member)
        let contains = self.inner[ratio]
        guard contains else { return nil }

        self.inner[ratio] = false
        self.count -= 1
        return member

    }

    public mutating func update(
        with newMember: __owned Element
    ) -> Element? {
        let ratio = self.ratio(for: newMember)
//        if !contains {
//
//        }
        fatalError()
    }



    public mutating func formIntersection(
        _ other: Self
    ) {

        fatalError()
    }

    public mutating func formSymmetricDifference(
        _ other: __owned Self
    ) {
//        self.reserveCapacity(other.capacity)
        fatalError()
    }
}

extension BitArray: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return lhs.inner == rhs.inner
    }
}

extension BitArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.count = 0
        self.inner = []

        guard let max = elements.max() else { return }
        self.reserveCapacity(for: max)
        elements.forEach {
            _ = self.insert($0)
        }
    }
}

extension BitArray: CustomStringConvertible {
    public var description: String {
        "BitArray(\(Array(self)))"
    }
}
