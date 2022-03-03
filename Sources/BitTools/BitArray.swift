public struct BitArray {
    public typealias Element = Int
    typealias Block = UInt64

    typealias Container = ContiguousArray<UInt64>

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

    public func makeIterator() -> AnyIterator<Int> {
        var blocks = self.inner.makeIterator()
        guard let fst = blocks.next() else { return AnyIterator { nil } }

        var bitCount = 0
        let nonzeroBitCount = self.count

        var bitBlockOffset = 0
        var bitIterator = BitIterator(fst)

        return AnyIterator {
            while bitCount < nonzeroBitCount {
                guard let next = bitIterator.next() else {
                    guard let nextBlock = blocks.next() else { return nil }
                    bitIterator = BitIterator(nextBlock)
                    bitBlockOffset += Block.bitWidth
                    continue
                }
                bitCount += 1
                return bitBlockOffset + Int(next)
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
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
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
        let capacity = Swift.min(self.capacity, other.capacity)

        var count = 0
        var inner = ContiguousArray<UInt64>(zeros: capacity)

        for i in 0..<capacity {
            let new = self.inner[i] & other.inner[i]
            count += new.nonzeroBitCount
            inner[i] = new
        }

        return Self(
            inner: inner,
            count: count
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
            inner: inner,
            count: count
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
//        let count = Swift.min(self.count, other.min)
//        for index in count {

//        }

        fatalError()
    }

    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }

}

extension BitArray {

    public mutating func removeAll(
        keepingCapacity keepCapacity: Bool = false
    ) {
        self.inner.zeroAll()
    }

    public mutating func removeAll(
        where shouldBeRemoved: (Self.Element) throws -> Bool
    ) rethrows {
//        for i in self.capacity {
//
//        }
        fatalError()
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

        if !lhs.inner[..<capacity].elementsEqual(rhs.inner[..<capacity]) {
            return false
        }
        let tail = lhs.inner[capacity...] ?? rhs.inner[capacity...]
        return tail.allZero()
    }
}

extension BitArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init()

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

extension BitArray {
    @inline(__always)
    public subscript(index: Int) -> Bool {
        get {
            self.inner[bit: index]
        }
        set {
            self.inner[bit: index] = newValue
        }
    }
}
