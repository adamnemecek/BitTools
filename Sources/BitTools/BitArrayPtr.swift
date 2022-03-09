@frozen
public struct BitArrayPtr: SetAlgebra {
    public typealias Block = UInt64
    public typealias Element = Int

    @usableFromInline
    internal private(set) var _count: Int

    @usableFromInline
    internal var _inner: ContiguousArray<Block>

    @inlinable @inline(__always)
    public var count: Int {
        self._count
    }

    init(count: Int, inner: ContiguousArray<Block>) {
        self._count = count
        self._inner = inner
    }

    public init() {
        self.init(count: 0, inner: [])
    }

    public init<S>(_ sequence: __owned S) where S: Sequence, Element == S.Element {
        self.init()

        guard let max = sequence.max() else { return }
        self.reserveCapacity(max + 1)
        sequence.forEach {
            _ = self.insert($0)
        }
    }
// }

// extension BitArrayPtr {
    @inlinable @inline(__always)
    public var capacity: Int {
        self._inner.count
    }

    @inline(__always)
    private func rawContains(_ idx: BitIndex) -> Bool {
        (self._inner[idx.blockIndex] & (1 << idx.bitIndex)) != 0
    }

    // insert without checking
    @inline(__always)
    private mutating func rawInsert(_ idx: BitIndex) {
        self._inner[idx.blockIndex] |= (1 << idx.bitIndex)
    }

    @inline(__always)
    private mutating func rawRemove(_ idx: BitIndex) {
        self._inner[idx.blockIndex] &= ~(1 << idx.bitIndex)
    }

    @inline(__always)
    private mutating func reserveCapacity(for bitIndex: BitIndex) {
        self.reserveCapacity(bitIndex.blocksNeeded)
    }
// }

// extension BitArrayPtr : SetAlgebra {

//    @inlinable @inline(__always)
    mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self._inner.count
        guard count > 0 else { return }
        self._inner.append(zeros: count)
    }

    public func union(_ other: Self) -> Self {
        fatalError()
    }

//    @inlinable @inline(__always)
//    public mutating func formUnion(_ other: __owned Self) {
//        let capacity = other.capacity
//        self.reserveCapacity(capacity)
//        self._count += self._inner.withUnsafeMutableBufferPointer { dst in
//            other._inner.withUnsafeBufferPointer { src in
//                dst.formUnion(src, capacity: capacity)
//            }
//        }
//    }

    public mutating func formUnion(
        _ other: __owned Self
    ) {
        self.reserveCapacity(other.capacity)

        var oldCount = 0
        var newCount = 0

        for i in 0 ..< other.capacity {
            let old = self._inner[i]
            let new = old | other._inner[i]

            oldCount += old.nonzeroBitCount
            newCount += new.nonzeroBitCount

            self._inner[i] = new
        }

        self._count += newCount - oldCount
    }

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

    public mutating func update(with newMember: Element) -> Element? {
        fatalError()
    }

    public func intersection(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formIntersection(_ other: Self) {
        fatalError()
    }

    public func symmetricDifference(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formSymmetricDifference(_ other: Self) {
        fatalError()
    }

    public mutating func subtract(_ other: Self) {
        fatalError()
    }

    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    public func contains(_ member: Element) -> Bool {
        fatalError()
    }

    public mutating func remove(_ member: Element) -> Element? {
        fatalError()
    }
}

extension BitArrayPtr: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements)
    }
}

extension BitArrayPtr: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        fatalError()
    }
}

extension BitArrayPtr: Sequence {
    public func makeIterator() -> BitArrayIterator {
        let bitCount = self._count
        return self._inner.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: bitCount)
        }
    }

    public var underestimatedCount: Int {
        self._count
    }
}
