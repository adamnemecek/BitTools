import KoreMetal
import Metal

public struct GPUBitArray {
    public private(set) var count: Int
    var inner: GPUArray<UInt64>
}

extension GPUBitArray: Sequence {
    public var underestimatedCount: Int {
        self.count
    }

    public func makeIterator() -> BitArrayIterator {
        let count = self.count
        return self.inner.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: count)
        }
    }
}


extension GPUBitArray : SetAlgebra {
    public typealias Element = Int

    public init(device: MTLDevice, capability: Int) {
        fatalError()
    }

    public init() {
        fatalError()
    }

    public func union(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formUnion(_ other: Self) {
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

    public mutating func remove(_ member: Element) -> Element? {
        fatalError()
    }

    public mutating func insert(
        _ newMember: Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }

    public mutating func subtract(_ other: Self) {
        fatalError()
    }

    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func update(with newMember: Element) -> Element? {
        fatalError()
    }
}
