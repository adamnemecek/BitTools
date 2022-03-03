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
        var bitCount = 0

        var blockIndex = 0
        let blockCount = self.inner.count

        var bitIterator = BitSequence(self.inner[blockIndex]).makeIterator()
        var bitBlockOffset = 0

        return AnyIterator {
            while bitCount < nonzeroBitCount {
                if let next = bitIterator.next() {
                    bitCount += 1
                    return bitBlockOffset + Int(next)
                }

                blockIndex += 1
                guard blockIndex < blockCount else { return nil }
                bitIterator = BitSequence(self.inner[blockIndex]).makeIterator()
                bitBlockOffset += Block.bitWidth
            }
            return nil
        }
    }

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
