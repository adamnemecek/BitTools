import Ext

@frozen
public struct BitArray {
    public typealias Element = Int
    typealias Block = UInt64

    public private(set) var count: Int
    private var inner: ContiguousArray<UInt64>

    ///
    /// capacity in blocks
    ///
    @inline(__always)
    public var capacity: Int {
        self.inner.count
    }

    @inline(__always)
    public var bitCapacity: Int {
        self.capacity << 6
    }

    @inline(__always)
    public var isEmpty: Bool {
        self.count == 0
    }

    @inline(__always)
    public var isSome: Bool {
        !self.isEmpty
    }

    public init() {
        self.init(count: 0, inner: [])
    }

    init(
        count: Int,
        inner: ContiguousArray<UInt64>
    ) {
        self.count = count
        self.inner = inner
    }
}

extension BitArray: Sequence {
    public typealias Iterator = BitArrayIterator

    @inline(__always)
    public var underestimatedCount: Int {
        self.count
    }

    @inline(__always)
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        try self.inner.withUnsafeBufferPointer(body)
    }

    @inline(__always)
    public func makeIterator() -> Iterator {
        let bitCount = self.count
        return self.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: bitCount)
        }
    }

    func makeIterator2() -> BitArrayIterator2 {
        let bitCount = self.count
        return self.withUnsafeBufferPointer {
            BitArrayIterator2(ptr: $0, nonzeroBitCount: bitCount)
        }
    }

//    @inline(__always)
//    public func makeIterator1() -> AnyIterator<Int> {
//        var blocks = self.inner.makeIterator()
//        guard let fst = blocks.next() else { return AnyIterator { nil } }
//
//        var remainingBitCount = self.count
//
//        var bitBlockOffset = 0
//        var bitIterator = BitIterator(fst)
//
//        return AnyIterator {
//            while remainingBitCount > 0 {
//                guard let next = bitIterator.next() else {
//                    guard let block = blocks.next() else {
//                        return nil
//                    }
//                    bitIterator = BitIterator(block)
//                    bitBlockOffset += Block.bitWidth
//                    continue
//                }
//                remainingBitCount -= 1
//                return bitBlockOffset + Int(next)
//            }
//            return nil
//        }
//    }
//
//
//    @inline(__always)
//    public func makeIterator2() -> AnyIterator<Int> {
//        guard !self.inner.isEmpty else { return AnyIterator { nil } }
//        var blockIndex = 0
//        let blockCount = self.inner.count
//        var block = self.inner[blockIndex]
//        var bitBlockOffset = 0
//        var remainingNonzeroBitCount = self.count
//        //
//        return AnyIterator {
//            while block == 0 {
//                blockIndex += 1
//                if remainingNonzeroBitCount == 0 || blockIndex == blockCount {
//                    return nil
//                }
//
//                block = self.inner[blockIndex]
//                bitBlockOffset += Block.bitWidth
//            }
//            remainingNonzeroBitCount -= 1
//            let trailing = block.trailingZeroBitCount
//            block = block & ~(1 << trailing)
//            return bitBlockOffset + trailing
//        }
//    }

}

extension BitArray: SetAlgebra {

    public init(capacity: Int) {
        self.count = 0
        self.inner = ContiguousArray(zeros: count)
    }

//    public init(bitCapacity: Int) {
//        self.count = 0
//        self.inner = []
//        self.reserveBitCapacity(bitCapacity)
//    }

    // call this after
    public mutating func recalculateCount() {
        self.count = self.nonzeroBitCount
    }

    ///
    /// this is in blocks
    ///
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        self.inner.append(zeros: count)
    }

    mutating func reserveCapacity(for value: Element) {
        let a = value.blockCount(bitWidth: Block.bitWidth)
        self.reserveCapacity(a)
    }

    mutating func reserveBitCapacity(_ bitCapacity: Int) {
        self.reserveCapacity(bitCapacity.roundUp(to: Block.bitWidth))
    }

    // done
    public __consuming func union(
        _ other: __owned Self
    ) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.order(other.capacity)

        var nonzeroBitCount = 0

        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        // combine the two that the arrays have in common
        for i in 0..<minCapacity {
            let new = self.inner[i] | other.inner[i]
            inner[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }

        // copy over the tail
        // note that only one of two loops will be executed, the
        // other one is empty

        assert(
            self.inner[minCapacity...].isEmpty
            || other.inner[minCapacity...].isEmpty
        )

        var idx = minCapacity

        for e in self.inner[minCapacity...] {
            inner[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        for e in other.inner[minCapacity...] {
            inner[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        return Self(
            count: nonzeroBitCount,
            inner: inner
        )
    }

    // done
    public mutating func formUnion(
        _ other: __owned Self
    ) {
        self.reserveCapacity(other.capacity)

        var oldCount = 0
        var newCount = 0

        for i in 0 ..< other.capacity {
            let old = self.inner[i]
            let new = old | other.inner[i]

            oldCount += old.nonzeroBitCount
            newCount += new.nonzeroBitCount

            self.inner[i] = new
        }

        self.count += newCount - oldCount
    }

//
//    public func nonzeroBitCount() -> Int {
//        self.inner.reduce(0) { $0 + $1.nonzeroBitCount }
//    }

    // done
    public __consuming func intersection(
        _ other: Self
    ) -> Self {
        let capacity = Swift.min(self.capacity, other.capacity)
        var nonzeroBitCount = 0

        var inner = ContiguousArray<UInt64>(zeros: capacity)

        for i in 0..<capacity {
            let new = self.inner[i] & other.inner[i]
            inner[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }

        return Self(
            count: nonzeroBitCount,
            inner: inner
        )
    }

    // done
    public mutating func formIntersection(
        _ other: Self
    ) {
        let capacity = Swift.min(self.capacity, other.capacity)
        var nonzeroBitCount = 0

        for i in 0 ..< capacity {
            let old = self.inner[i]
            let new = old & other.inner[i]

            self.inner[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }
        // elements that are only in the current need to be removed
        self.inner[capacity...].zeroAll()
        self.count = nonzeroBitCount
    }

    func ratio(for member: Int) -> Ratio<Int> {
        member.ratio(Block.bitWidth)
    }

    // done?
    public __consuming func symmetricDifference(
        _ other: __owned Self
    ) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.order(other.capacity)

        var nonzeroBitCount = 0

        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        // combine the two parts that the arrays have in common
        for i in 0..<minCapacity {
            let new = self.inner[i] ^ other.inner[i]

            inner[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }

        // copy over the tail
        // note that only one of two loops will be executed, the
        // other one is empty

        assert(
            self.inner[minCapacity...].isEmpty
            || other.inner[minCapacity...].isEmpty
        )

        var idx = minCapacity

        for e in self.inner[minCapacity...] {
            inner[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        for e in other.inner[minCapacity...] {
            inner[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        return Self(
            count: nonzeroBitCount,
            inner: inner
        )
    }

    public mutating func formSymmetricDifference(
        _ other: __owned Self
    ) {
        // resize
        // go through the shared length and count
        self.reserveCapacity(other.capacity)

        var oldCount = 0
        var newCount = 0

        for i in 0 ..< other.capacity {
            let old = self.inner[i]
            let new = old ^ other.inner[i]

            self.inner[i] = new

            oldCount += old.nonzeroBitCount
            newCount += new.nonzeroBitCount
        }

        self.count += newCount - oldCount
    }


    public mutating func subtract(_ other: Self) {
        // remove elements in the other set from this set

        var oldCount = 0
        var newCount = 0

        let capacity = Swift.min(self.capacity, other.capacity)

        for i in 0..<capacity {
            let old = self.inner[i]
            let new = old & ~other.inner[i]

            self.inner[i] = new

            oldCount += old.nonzeroBitCount
            newCount += new.nonzeroBitCount
        }

        self.count += newCount - oldCount
    }


    public func subtracting(_ other: Self) -> Self {
        // this is essentially intersect but with a different operator, capacity
        // and the fact that we are copying the tail
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.order(other.capacity)

        var nonzeroBitCount = 0

        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        for i in 0..<minCapacity {
            let new = self.inner[i] & ~other.inner[i]
            inner[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }

        var idx = minCapacity
        for e in self.inner[minCapacity...] {
            inner[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        return Self(
            count: nonzeroBitCount,
            inner: inner
        )
    }

//    public func isSubset(of other: Self) -> Bool {
//        fatalError()
//    }
//
//    public func isSuperset(of other: Self) -> Bool {
//        fatalError()
//    }
//
//    public func isDisjoint(with other: Self) -> Bool {
//        fatalError()
//    }

//    public func isStrictSubset(of other: Self) -> Bool {
//        fatalError()
//    }


//    x.isSubset(of: y) implies x.union(y) == y
//
//    x.isSuperset(of: y) implies x.union(y) == x
//
//    x.isSubset(of: y) if and only if y.isSuperset(of: x)
//
//    x.isStrictSuperset(of: y) if and only if x.isSuperset(of: y) && x != y
//
//    x.isStrictSubset(of: y) if and only if x.isSubset(of: y) && x != y

    @inline(__always)
    private func rawContains(_ idx: BlockIndex) -> Bool {
        (self.inner[idx.blockIndex] & (1 << idx.bitIndex)) != 0
    }

    // insert without checking
    @inline(__always)
    mutating func rawInsert(_ idx: BlockIndex) {
        self.inner[idx.blockIndex] |= (1 << idx.bitIndex)
    }

    @inline(__always)
    mutating func rawRemove(_ idx: BlockIndex) {
        self.inner[idx.blockIndex] &= ~(1 << idx.bitIndex)
    }

    public mutating func insert(
        _ newMember: __owned Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        self.reserveCapacity(for: newMember)

        let index = blockIndex(newMember)

        let contains = self.rawContains(index)

        guard !contains else { return (false, newMember) }
        self.rawInsert(index)
        self.count += 1
        return (true, newMember)

    }

    public func contains(
        _ member: Element
    ) -> Bool {
        assert(member >= 0)
        guard member < self.bitCapacity else { return false }
        return self.rawContains(BlockIndex(member))
    }

    public mutating func remove(
        _ member: Element
    ) -> Element? {
        guard member < self.bitCapacity else { return nil }
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



}

extension BitArray {
    public mutating func removeAll(
        keepingCapacity keepCapacity: Bool = false
    ) {
        self.count = 0
        self.inner.zeroAll()
    }

    public mutating func removeAll(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows {
        var i = self.makeIterator2()
        while let (value, block, bit) = i.next() {
            if try shouldBeRemoved(value) {
                self.inner[block].remove(bit: UInt64(bit))
                self.count -= 1
            }
        }
    }
}

extension BitArray: Equatable {
    ///
    /// theoretically one bitset could be longer than the other and have only zeros in the tail
    /// in which case the `BitArray`s are zero
    ///
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        let capacity = Swift.min(lhs.capacity, rhs.capacity)

        let tail = lhs.inner[capacity...] || rhs.inner[capacity...]
        return tail.allZeros() || lhs.inner[..<capacity].elementsEqual(rhs.inner[..<capacity])
    }
}

extension BitArray {
    public init<S>(_ sequence: __owned S) where S: Sequence, Int == S.Element {
        self.init()

        guard let max = sequence.max() else { return }
        self.reserveCapacity(for: max)
        sequence.forEach {
            _ = self.insert($0)
        }
    }
}

extension BitArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension BitArray: CustomStringConvertible {
    public var description: String {
        "BitArray(\(Array(self)))"
    }
}

extension BitArray {
    @inline(__always)
    public subscript(index: Int) -> Bool {
        get {
            self.inner[bit: index]
        }
        set {
            switch (self.inner[bit: index], newValue) {
            case (true, false):
                count -= 1
            case (false, true):
                count += 1
            default:
                break
            }
            self.inner[bit: index] = newValue
        }
    }
}

extension BitArray {
    subscript(block: BlockIndex) -> Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

@inline(__always)
func blockIndex(_ value: Int) -> BlockIndex {
    // 2^6 = 64
    let blockIndex = value >> 6

    let ret = BlockIndex(
        blockIndex: blockIndex,
        bitIndex: value - (blockIndex << 6)
    )

    assert(ret.value == value)
    return ret
}

// this is a divrem with 64
struct BlockIndex : Equatable {
    let blockIndex: Int
    let bitIndex: Int

    init(blockIndex: Int, bitIndex: Int) {
        self.blockIndex = blockIndex
        self.bitIndex = bitIndex
    }

    init(_ value: Int) {
        // 2^6 = 64
        let blockIndex = value >> 6

        self.init(
            blockIndex: blockIndex,
            bitIndex: value - (blockIndex << 6)
        )

        assert(self.value == value)
    }

    var value: Int {
        self.blockIndex << 6 + self.bitIndex
    }
}
