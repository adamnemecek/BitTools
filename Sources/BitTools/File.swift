import KoreMetal

public struct GPUBitArray {
    var count: Int
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
