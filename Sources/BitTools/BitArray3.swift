
public struct BitArray3 {
    public typealias Element = Int

    public private(set) var count: Int
    private var inner: ContiguousArray<UInt64>

    init(count: Int, inner: ContiguousArray<UInt64>) {
        self.count = count
        self.inner = inner
    }

    public init() {
        self.init(count: 0, inner: [])
    }

    public init<S>(_ sequence: __owned S) where S : Sequence, Element == S.Element {
        self.init()

        guard let max = sequence.max() else { return }
        self.reserveCapacity(max + 1)
        sequence.forEach {
            _ = self.insert($0)
        }
    }
}

extension BitArray3 : SetAlgebra {

    @inline(__always)
    private func rawContains(_ idx: BlockIndex) -> Bool {
        (self.inner[idx.blockIndex] & (1 << idx.bitIndex)) != 0
    }

    // insert without checking
    @inline(__always)
    private mutating func rawInsert(_ idx: BlockIndex) {
        self.inner[idx.blockIndex] |= (1 << idx.bitIndex)
    }

    @inline(__always)
    private mutating func rawRemove(_ idx: BlockIndex) {
        self.inner[idx.blockIndex] &= ~(1 << idx.bitIndex)
    }

    mutating func reserveCapacity(for blockIndex: BlockIndex) {
        self.reserveCapacity(blockIndex.blocksNeeded)
    }

    mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        self.inner.append(zeros: count)
    }

    public func union(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formUnion(_ other: Self) {
        let capacity = other.inner.capacity
        self.reserveCapacity(capacity)
        self.count += self.inner.withUnsafeMutableBufferPointer { dst in
            other.inner.withUnsafeBufferPointer { src in
                dst.formUnion(src, capacity: capacity)
            }
        }
    }

    public mutating func insert(
        _ newMember: __owned Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        let blockIndex = blockIndex(newMember)

        self.reserveCapacity(for: blockIndex)

        let contains = self.rawContains(blockIndex)

        guard !contains else { return (false, newMember) }
        self.rawInsert(blockIndex)
        self.count += 1
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

extension BitArray3: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements)
    }
}

extension BitArray3: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        fatalError()
    }
}

extension BitArray3: Sequence {
    public func makeIterator() -> BitArrayIterator {
        let bitCount = self.count
        return self.inner.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: bitCount)
        }
    }

    public var underestimatedCount: Int {
        self.count
    }
}
