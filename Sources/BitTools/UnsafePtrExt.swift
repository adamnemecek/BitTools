
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


extension UnsafeMutableBufferPointer where Element == UInt64 {

    @inline(__always)
    mutating func formBitOp(
        _ other: UnsafeBufferPointer<Element>,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int  {
        var bitCount = 0

        guard var i = self.baseAddress,
              var j = other.baseAddress else { fatalError() }

        for _ in 0..<count {
            let new = op(i.pointee, j.pointee)
            bitCount += new.nonzeroBitCount
            i.pointee = new

            i = i.successor()
            j = j.successor()
        }
        return bitCount
    }

    mutating func formOr(
        _ other: UnsafeBufferPointer<Element>,
        count: Int
    ) -> Int {
        self.formBitOp(other, count: count, op: |)
    }

    mutating func formAnd(
        _ other: UnsafeBufferPointer<Element>,
        count: Int
    ) -> Int {
        self.formBitOp(other, count: count, op: &)
    }

    mutating func formXor(
        _ other: UnsafeBufferPointer<Element>,
        count: Int
    ) -> Int {
        self.formBitOp(other, count: count, op: ^)
    }

    mutating func bitCopy(
        _ other: UnsafeBufferPointer<Element>,
        count: Int
    ) -> Int {

        var bitCount = 0

        guard var i = self.baseAddress,
              var j = other.baseAddress else { fatalError() }

        for _ in 0..<count {
            let new = j.pointee
            bitCount += new.nonzeroBitCount
            i.pointee = new

            i = i.successor()
            j = j.successor()
        }
        return bitCount
    }


    public func formUnion(_ other: UnsafeBufferPointer<Element>, count: Int) -> Int {
        guard var a = self.baseAddress,
              var b = other.baseAddress else { fatalError() }

        var bitCount = 0
        for _ in 0..<count {
            let new = a.pointee | b.pointee
            a = a.successor()
            b = b.successor()
            a.pointee = new
            bitCount += new.nonzeroBitCount
        }
        return bitCount
    }

    public func formIntersection(_ other: UnsafeBufferPointer<Element>, count: Int) -> Int {
        guard var a = self.baseAddress,
              var b = other.baseAddress else { fatalError() }

        var bitCount = 0
        for _ in 0..<count {
            let new = a.pointee & b.pointee
            a = a.successor()
            b = b.successor()
            a.pointee = new
            bitCount += new.nonzeroBitCount
        }
        return bitCount
    }

//    func copy(_ other: )
}
