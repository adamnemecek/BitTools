
extension UnsafeBufferPointer {
    @inlinable @inline(__always)
    func advanced(by count: Int) -> Self {
        let newCount = self.count - count
        guard let base = self.baseAddress, newCount > 0 else { fatalError() }
        return Self(start: base.advanced(by: count), count: newCount)
    }
}

extension UnsafeMutableBufferPointer {
    @inlinable @inline(__always)
    func advanced(by count: Int) -> Self {
        let newCount = self.count - count
        guard let base = self.baseAddress, newCount > 0 else { fatalError() }
        return Self(start: base.advanced(by: count), count: newCount)
    }
}

extension MutableCollection where Element: FixedWidthInteger {
//    mutating func formBitOp<C>(
//        _ other: C,
//        count: Int,
//        op: (Element, Element) -> Element
//    ) -> Int where C: Collection, C.Element == Element {
////        var nonzeroBitCount = 0
////
////        var i = self.startIndex
////        var j = other.startIndex
////
////        for _ in 0..<count {
////            let new = op(self[i], other[j])
////            nonzeroBitCount += new.nonzeroBitCount
////            self[i] = new
////
////            i = self.index(after: i)
////            j = other.index(after: j)
////        }
////        return nonzeroBitCount
//        self.bitOp(self, other, count: count, op: op)
//    }


//    mutating func bitOp<A, B>(
//        _ a: A,
//        _ b: B,
//        count: Int,
//        op: (Element, Element) -> Element
//    ) -> Int where A: Collection, A.Element == Element, B: Collection, B.Element == Element {
//        var nonzeroBitCount = 0
//
//        var i = self.startIndex
//        var j = a.startIndex
//        var k = b.startIndex
//
//        for _ in 0..<count {
//            let new = op(a[j], b[k])
//            nonzeroBitCount += new.nonzeroBitCount
//            self[i] = new
//
//            i = self.index(after: i)
//            j = a.index(after: j)
//            k = b.index(after: k)
//        }
//        return nonzeroBitCount
//    }
}


extension UnsafeMutableBufferPointer where Element == UInt64 {

    @inline(__always)
    mutating func formBitOp(
        _ other: UnsafeBufferPointer<Element>,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int  {
        var nonzeroBitCount = 0


        guard var i = self.baseAddress,
              var j = other.baseAddress else { fatalError() }

        for _ in 0..<count {
            let new = op(i.pointee, j.pointee)
            nonzeroBitCount += new.nonzeroBitCount
            i.pointee = new

            i = i.successor()
            j = j.successor()
        }
        return nonzeroBitCount
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

    mutating func bitOp(
        _ a: UnsafeBufferPointer<Element>,
        _ b: UnsafeBufferPointer<Element>,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int  {
        var nonzeroBitCount = 0

        var i = self.startIndex
        var j = a.startIndex
        var k = b.startIndex

        for _ in 0..<count {
            let new = op(a[j], b[k])
            nonzeroBitCount += new.nonzeroBitCount
            self[i] = new

            i = self.index(after: i)
            j = a.index(after: j)
            k = b.index(after: k)
        }
        return nonzeroBitCount
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
