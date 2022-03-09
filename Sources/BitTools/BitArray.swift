import Ext
///
/// some of this is based on BigInt
/// this file has a lot of bitshifting by 6 since 2^6 = 64
///

@frozen
public struct BitArray {
    public typealias Element = Int
    public typealias Block = UInt64

    @usableFromInline
    internal var _count: Int


    ///
    /// number of set bits
    ///
    @inline(__always) @inlinable
    public var count: Int {
        self._count
    }

    @usableFromInline
    internal var inner: ContiguousArray<Block>

    ///
    /// capacity in blocks
    ///
    @inline(__always) @inlinable
    public var capacity: Int {
        self.inner.count
    }

    @inline(__always) @inlinable
    public var bitCapacity: Int {
        self.capacity << 6
    }

    @inline(__always) @inlinable
    public var isEmpty: Bool {
        self._count == 0
    }

    @inline(__always) @inlinable
    public var isSome: Bool {
        !self.isEmpty
    }

    @inline(__always) @inlinable
    public init() {
        self.init(count: 0, inner: [])
    }

    @inline(__always) @inlinable
    init(
        count: Int,
        inner: ContiguousArray<Block>
    ) {
        self._count = count
        self.inner = inner
    }
}

extension BitArray: Sequence {
    public typealias Iterator = BitArrayIterator

    @inline(__always) @inlinable
    public var underestimatedCount: Int {
        self._count
    }

    @inline(__always) @inlinable
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        try self.inner.withUnsafeBufferPointer(body)
    }

    @inline(__always) @inlinable
    public func makeIterator() -> Iterator {
        let bitCount = self._count
        return self.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: bitCount)
        }
    }

    func makeIterator2() -> BitArrayIterator2 {
        let bitCount = self._count
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
        self._count = 0
        self.inner = ContiguousArray(zeros: _count)
    }

    // call this after
    public mutating func recalculateCount() {
        self._count = self.nonzeroBitCount
    }

    ///
    /// this is in blocks
    ///
    @inline(__always) @inlinable
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        self.inner.append(zeros: count)
    }

    @inline(__always) @inlinable
    mutating func reserveCapacity(for bitIndex: BitIndex) {
        self.reserveCapacity(bitIndex.blocksNeeded)
    }

    // done
    public __consuming func union(
        _ other: __owned Self
    ) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.order(other.capacity)

        var inner = ContiguousArray<Block>(zeros: maxCapacity)

        var nonzeroBitCount = 0

        // combine the two that the arrays have in common
        for i in 0 ..< minCapacity {
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

        self._count += newCount - oldCount
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

        var inner = ContiguousArray<Block>(zeros: capacity)

        for i in 0 ..< capacity {
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
        self._count = nonzeroBitCount
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

        var inner = ContiguousArray<Block>(zeros: maxCapacity)

        // combine the two parts that the arrays have in common
        for i in 0 ..< minCapacity {
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

        self._count += newCount - oldCount
    }

    public mutating func subtract(_ other: Self) {
        // remove elements in the other set from this set

        var oldCount = 0
        var newCount = 0

        let capacity = Swift.min(self.capacity, other.capacity)

        for i in 0 ..< capacity {
            let old = self.inner[i]
            let new = old & ~other.inner[i]

            self.inner[i] = new

            oldCount += old.nonzeroBitCount
            newCount += new.nonzeroBitCount
        }

        self._count += newCount - oldCount
    }

    public func subtracting(_ other: Self) -> Self {
        // this is essentially intersect but with a different operator, capacity
        // and the fact that we are copying the tail
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.order(other.capacity)

        var nonzeroBitCount = 0

        var inner = ContiguousArray<Block>(zeros: maxCapacity)

        for i in 0 ..< minCapacity {
            let new = self.inner[i] & ~other.inner[i]

            inner[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }

        // we copy only the tail of self
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

    @inline(__always) @inlinable
    public func isSubset(of other: Self) -> Bool {
        let capacity = Swift.min(self.capacity, other.capacity)

        for i in 0 ..< capacity {
            let a = self.inner[i]
            let b = other.inner[i]

            //
            // we are checking that the other set has at
            // least all the bits that this set has
            //
            if (a & b) != a {
                return false
            }
        }

        return true
    }

    ///
    /// - `x.isSubset(of: y)` if and only if `y.isSuperset(of: x)`
    ///
    @inline(__always) @inlinable
    public func isSuperset(of other: Self) -> Bool {
        other.isSubset(of: self)
    }

    @inline(__always) @inlinable
    public func isDisjoint(with other: Self) -> Bool {
        let capacity = Swift.min(self.capacity, other.capacity)

        //
        //
        //
        for i in 0 ..< capacity {
            if (self.inner[i] & other.inner[i]) != 0 {
                return false
            }
        }
        return true
    }

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

    // note that none of the raw apis update the count
    @inline(__always) @inlinable
    func rawContains(_ idx: BitIndex) -> Bool {
        (self.inner[idx.blockIndex] & (1 << idx.bitIndex)) != 0
    }

    // insert without checking
    @inline(__always) @inlinable
    mutating func rawInsert(_ idx: BitIndex) {
        self.inner[idx.blockIndex] |= (1 << idx.bitIndex)
    }

    @inline(__always) @inlinable
    mutating func rawRemove(_ idx: BitIndex) {
        self.inner[idx.blockIndex] &= ~(1 << idx.bitIndex)
    }

    @inline(__always) @inlinable
    public func contains(
        _ member: Element
    ) -> Bool {
        assert(member >= 0)
        guard member < self.bitCapacity else { return false }
        return self.rawContains(bitIndex(member))
    }

    @discardableResult
    @inline(__always) @inlinable
    public mutating func insert(
        _ newMember: __owned Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        let bitIndex = bitIndex(newMember)

        self.reserveCapacity(for: bitIndex)

        let contains = self.rawContains(bitIndex)

        guard !contains else { return (false, newMember) }
        self.rawInsert(bitIndex)
        self._count += 1
        return (true, newMember)
    }

    @discardableResult
    @inline(__always) @inlinable
    public mutating func remove(
        _ member: Element
    ) -> Element? {
        assert(member >= 0)
        guard member < self.bitCapacity else { return nil }
        let bitIndex = bitIndex(member)
        guard self.rawContains(bitIndex) else { return nil }
        self.rawRemove(bitIndex)
        self._count -= 1
        return member
    }

    @discardableResult
    @inline(__always) @inlinable
    public mutating func update(
        with newMember: __owned Element
    ) -> Element? {
        if self.insert(newMember).inserted {
            return nil
        }
        return newMember
    }
}

extension BitArray {
    public mutating func removeAll(
        keepingCapacity keepCapacity: Bool = false
    ) {
        self._count = 0
//        self.inner.removeAll(keepingCapacity: true)
        self.inner.zeroAll()
    }

    public mutating func removeAll(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows {
        var i = self.makeIterator2()
        while let (value, index) = i.next() {
            if try shouldBeRemoved(value) {
                self.rawRemove(index)
                self._count -= 1
            }
        }
    }
}

extension BitArray: Equatable {
    ///
    /// theoretically one bitset could be longer than the other and have only zeros in the tail
    /// in which case the `BitArray`s are zero
    ///
    @inline(__always) @inlinable
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs._count == rhs._count else { return false }
//        let (
//            minCapacity,
//            maxCapacity
//        ) = lhs.capacity.order(rhs.capacity)
        let capacity = Swift.min(lhs.capacity, rhs.capacity)

//        return lhs.inner[...capacity] == rhs.inner[...capacity] &&
//                lhs.inner[capacity...].allZeros() &&
//                rhs.inner[capacity...].allZeros()

        for i in 0 ..< capacity where lhs.inner[i] != rhs.inner[i] {
            return false
        }

        // only one of these two loops is executed
        for e in lhs.inner[capacity...] where e != 0 {
            return false
        }

        for e in rhs.inner[capacity...] where e != 0 {
            return false
        }

        return true
    }
}

extension BitArray {
    public init<S>(_ sequence: __owned S) where S: Sequence, Element == S.Element {
        self.init()

        guard let max = sequence.max() else { return }
        self.reserveCapacity(for: bitIndex(max))
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
    @inline(__always) @inlinable
    public subscript(index: Int) -> Bool {
        get {
            self.contains(index)
        }
        set {
//            let blockIndex = blockIndex(index)
            let oldValue = self.contains(index)
            guard oldValue != newValue else { return }

            // this means that either we are adding or removing
            // if it was false and it's set to false, noop
            // if true, true, noop as well
            //
            // 0, 0 =>  0
            // 1, 0 => -1
            // 0, 1 =>  1
            // 1, 1 =>  0
            //

            if oldValue {
                // we are removing
                _ = self.remove(index)
//                self.rawRemove(blockIndex)
//                self.count -= 1
            } else {
                _ = self.insert(index)
                // we are adding
//                self.rawInsert(blockIndex)
//                self.count += 1
            }
        }
    }
}

// extension BitArray {
//    subscript(block: BitIndex) -> Bool {
//        get {
//            fatalError()
//        }
//        set {
//            fatalError()
//        }
//    }
// }
