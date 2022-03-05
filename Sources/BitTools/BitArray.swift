public struct BitArray {
    public typealias Element = Int
    typealias Block = UInt64

    public private(set) var count: Int
    private var inner: ContiguousArray<UInt64>

    ///
    /// capacity in blocks
    ///
    public var capacity: Int {
        self.inner.count
    }

    public var bitCapacity: Int {
        self.capacity * Block.bitWidth
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
        self.count = 0
        self.inner = []
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

    @inline(__always)
    public func makeIterator() -> AnyIterator<Int> {
        var blocks = self.inner.makeIterator()
        guard let fst = blocks.next() else { return AnyIterator { nil } }

        var remainingBitCount = self.count

        var bitBlockOffset = 0
        var bitIterator = BitIterator(fst)

        return AnyIterator {
            while remainingBitCount > 0 {
                guard let next = bitIterator.next() else {
                    guard let block = blocks.next() else {
                        return nil
                    }
                    bitIterator = BitIterator(block)
                    bitBlockOffset += Block.bitWidth
                    continue
                }
                remainingBitCount -= 1
                return bitBlockOffset + Int(next)
            }
            return nil
        }
    }

    @inline(__always)
    public func makeIterator1() -> AnyIterator<Int> {
        guard !self.isSome && !self.inner.isEmpty else { return AnyIterator { nil } }
        var blockIndex = 0
        let blockCount = self.inner.count

        var block = self.inner[blockIndex]
        var blockRemainingNonzeroBitCount = block.nonzeroBitCount
        var bitBlockOffset = 0


//        var remainingB
        var remainingNonzeroBitCount = self.count
//
////        var = blockNonzeroBitCount
//        var bitCount = 0
//
        return AnyIterator {
            while remainingNonzeroBitCount > 0 {
                if blockRemainingNonzeroBitCount == 0 {

                    blockIndex += 1
                    if blockIndex == blockCount {
                        return nil
                    }
                    block = self.inner[blockIndex]
                    blockRemainingNonzeroBitCount = block.nonzeroBitCount
                    bitBlockOffset += Block.bitWidth
                    continue
                }
                remainingNonzeroBitCount -= 1
                let trailing = block.trailingZeroBitCount
                block = block & ~(1 << trailing)
                return bitBlockOffset + trailing
            }
            return nil
        }
    }

//    public func makeIterator() -> AnyIterator<Int> {
//           var blocks = self.inner.makeIterator()
//
//           guard let fst = blocks.next() else { return AnyIterator { nil } }
//
//           let nonzeroBitCount = self.count
//           var bitCount = 0
//
//           var bitIterator = BitIterator(fst)
//           var bitBlockOffset = 0
//
//           return AnyIterator {
//               while bitCount < nonzeroBitCount {
//                   if let next = bitIterator.next() {
//                       bitCount += 1
//                       return bitBlockOffset + Int(next)
//                   }
//
//                   if let nextBlock = blocks.next() {
//                       bitIterator = BitIterator(nextBlock)
//                       bitBlockOffset += Block.bitWidth
//                   } else {
//                       return nil
//                   }
//               }
//               return nil
//           }
//       }
    public var underestimatedCount: Int {
        self.count
    }
}

extension BitArray: SetAlgebra {

    public init(capacity: Int) {
        self.count = 0
        self.inner = ContiguousArray(zeros: count)
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

    public __consuming func union(
        _ other: __owned Self
    ) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        var count = 0
        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        for i in 0..<minCapacity {
            let new = self.inner[i] | other.inner[i]
            count += new.nonzeroBitCount
            inner[i] = new
        }

        let tail = self.inner[minCapacity...] ??
                    other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            inner[i] = new
            count += new.nonzeroBitCount
        }

        return Self(
            count: count,
            inner: inner
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
            self.inner[i] = new
            count += new.nonzeroBitCount
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
        let capacity = Swift.min(self.capacity, other.capacity)

        var count = 0
        var inner = ContiguousArray<UInt64>(zeros: capacity)

        for i in 0..<capacity {
            let new = self.inner[i] & other.inner[i]
            count += new.nonzeroBitCount
            inner[i] = new
        }

        return Self(
            count: count,
            inner: inner
        )
    }

    public mutating func formIntersection(
        _ other: Self
    ) {
        let capacity = Swift.min(self.capacity, other.capacity)

        var count = 0
        for i in 0..<capacity {
            let new = self.inner[i] & other.inner[i]
            count += new.nonzeroBitCount
            self.inner[i] = new
        }

        self.count = count
    }

    func ratio(for member: Int) -> Ratio {
        member.ratio(Block.bitWidth)
    }

    public __consuming func symmetricDifference(
        _ other: __owned Self
    ) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        var count = 0
        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        for i in 0..<minCapacity {
            let new = self.inner[i] ^ other.inner[i]
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
            count: count,
            inner: inner
        )
    }

    public mutating func formSymmetricDifference(
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

    public mutating func subtract(_ other: Self) {
        let capacity = Swift.min(self.capacity, other.capacity)
        for i in 0..<capacity {
            self.inner[i].subtract(bits: other.inner[i])
        }
    }

    public func subtracting(_ other: Self) -> Self {
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

        var i = (0..<self.inner.count).makeIterator()

        var blockBitOffset = 0
        var count = 0

        let nonzeroBitCount = self.nonzeroBitCount
        var newCount = 0

        while let index = i.next(), count < nonzeroBitCount {
            let current = self.inner[index]
            count += current.nonzeroBitCount

            let new = try current.removingAll {
                try shouldBeRemoved(blockBitOffset + Int($0))
            }

            newCount += new.nonzeroBitCount
            self.inner[index] = new
            blockBitOffset += Block.bitWidth
        }
        self.count = newCount
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

        let tail = lhs.inner[capacity...] ?? rhs.inner[capacity...]
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
