import KoreMetal
import Metal

public struct GPUBitArray {
    public private(set) var count: Int
    var inner: GPUArray<UInt64>
}

extension GPUBitArray: Sequence {
    public func makeIterator() -> BitArrayIterator {
        let count = self.count
        return self.inner.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: count)
        }
    }
}

extension MutableCollection where Element: FixedWidthInteger {
    mutating func formBitOp<C>(
        _ other: C,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int where C: Collection, C.Element == Element {
        var bitCount = 0

        var i = self.startIndex
        var j = other.startIndex

        for _ in 0..<count {
            let new = op(self[i], other[j])
            bitCount += new.nonzeroBitCount
            self[i] = new

            i = self.index(after: i)
            j = other.index(after: j)
        }
        return bitCount
    }

    mutating func bitOp<A, B>(
        _ a: A,
        _ b: B,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int where A: Collection, A.Element == Element, B: Collection, B.Element == Element {
        var bitCount = 0

        var i = self.startIndex
        var j = a.startIndex
        var k = b.startIndex

        for _ in 0..<count {
            let new = op(a[j], b[k])
            bitCount += new.nonzeroBitCount
            self[i] = new

            i = self.index(after: i)
            j = a.index(after: j)
            k = b.index(after: k)
        }
        return bitCount
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
