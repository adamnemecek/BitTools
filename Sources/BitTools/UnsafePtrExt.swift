
extension UnsafeBufferPointer {
    @inlinable @inline(__always)
    func advanced(by count: Int) -> Self {
        let newCount = self.count - count
        guard let base = self.baseAddress, newCount > 0 else { fatalError() }
        return Self(start: base.advanced(by: count), count: newCount)
    }

    subscript(range: Range<Int>) -> Self {
        fatalError()
    }
}

extension UnsafeMutableBufferPointer {
    @inlinable @inline(__always)
    func advanced(by count: Int) -> Self {
        let newCount = self.count - count
        guard let base = self.baseAddress, newCount > 0 else { fatalError() }
        return Self(start: base.advanced(by: count), count: newCount)
    }

    subscript(range: Range<Int>) -> Self {
        fatalError()
    }
}

//
//struct UnsafeBitMaskBufferPointer {
//    var nonzeroBitCount: Int
//    var ptr: UnsafeBufferPointer<UInt64>
//}
//
//extension UnsafeBitMaskBufferPointer {
//    public static func |(lhs: Self, rhs: Self) -> Self {
//        fatalError()
//    }
//
//    subscript(range: Range<Int>) -> UnsafeBitMaskBufferPointer {
//        fatalError()
//    }
//}

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

//extension Sequence where Element : FixedWidthInteger {
//    public static func |(lhs: Self, rhs: Self) -> Zip2Sequence<Self, Self> {
//
//        sequence(state: <#T##State#>, next: <#T##(inout State) -> T?#>)
//    }
//}

//struct OrIterator: IteratorProtocol {
//    init(a: UnsafeBufferPointer<UInt64>, b: UnsafeBufferPointer<UInt64>) {
//        fatalError()
//    }
//
//    func next() -> Element? {
//        fatalError()
//    }
//}

extension RangeReplaceableCollection where Self: BidirectionalCollection {
    @inlinable @inline(__always)
    public mutating func truncate(to count: Int) {
        fatalError()
//        guard count > self.count else { return }
//        self.removeLast(10)
    }
}

extension MutableCollection {
    @inlinable @inline(__always)
    public mutating func replaceSubrange(_ subrange: Range<Index>, with element: Element) {
        var startIndex = subrange.lowerBound
        let endIndex = subrange.upperBound

        while startIndex != endIndex {
            self[startIndex] = element
            startIndex = self.index(after: startIndex)
        }
    }

    public mutating func mapSubrange<S>(
        subrange: Range<Index>,
        _ other: S,
        _ transform: (Element, S.Element) -> Element
    ) -> Int where S: Sequence{
        var i = other.makeIterator()

        var startIndex = subrange.lowerBound
        let endIndex = subrange.upperBound

        while startIndex != endIndex {
            self[startIndex] = transform(self[startIndex], i.next()!)
            startIndex = self.index(after: startIndex)
        }
//        return 0
        fatalError()
    }
}

//extension RangeReplaceableCollection {
//    @inlinable @inline(__always)
//    mutating func append<S>(
//        contentsOf newElements: S,
//        _ body: (Element) -> Void
//    ) -> Int where S : Sequence, Self.Element == S.Element {
//
//        self.reserveCapacity(newElements.underestimatedCount)
//
//        var offset = 0
//
//        for e in newElements {
//            self.append(e)
//            body(e)
//            offset += 1
//        }
//
//        return offset
//    }
//}


///////////////// push

extension RangeReplaceableCollection where Element: FixedWidthInteger {
    

    mutating func bitAppend<S>(_ other: S) -> (
        offset: Int,
        nonzeroBitCount: Int
    ) where S: Collection, S.Element == Element {

        self.reserveCapacity(other.underestimatedCount)

        var offset = 0
        var nonzeroBitCount = 0

        for e in other {
            self.append(e)
            nonzeroBitCount += e.nonzeroBitCount
            offset += 1
        }

        return (offset + 1, nonzeroBitCount)
    }
}

extension UnsafeMutableBufferPointer {
//    @inlinable @inline(__always)
//    public func initialize<S>(
//        from source: S,
//        _ op: (Element) -> Void
//    ) -> (
//        iter: S.Iterator,
//        offset: Index
//    ) where S : Sequence, Element == S.Element  {
//
//        fatalError()
//        var src = source.makeIterator()
//        var offset = 0
//
//        guard var dst = self.baseAddress else { return (src, offset) }
//
//        while let next = src.next() {
//            offset += 1
//        }
//
//        return (src, offset + 1)
//
//    }
}

extension UnsafeMutableBufferPointer where Element == UInt64 {

//    func assign(
//        _ other: UnsafeBufferPointer<Element>
//    ) {
//
//        fatalError()
//    }

    //    mutating func formOr(
    //        _ other: UnsafeBufferPointer<Element>,
    //        count: Int
    //    ) -> Int {
    //        self.formBitOp(other, count: count, op: |)
    //    }
    //
    //    mutating func formAnd(
    //        _ other: UnsafeBufferPointer<Element>,
    //        count: Int
    //    ) -> Int {
    //        self.formBitOp(other, count: count, op: &)
    //    }
    //
    //    mutating func formXor(
    //        _ other: UnsafeBufferPointer<Element>,
    //        count: Int
    //    ) -> Int {
    //        self.formBitOp(other, count: count, op: ^)
    //    }

    @inlinable @inline(__always)
    func bitOp(
        _ other: UnsafeBufferPointer<Element>,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int  {
//        assert(self.count <= count)
        guard other.isSome, count > 0 else { return 0 }

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

    func zeroAll() {
        fatalError()
    }


//    @inlinable @inline(__always)
//    func bitCopy(
//        _ other: UnsafeBufferPointer<Element>
//    ) -> Int {
//        guard other.isSome else { return 0 }
//
//        var nonzeroBitCount = 0
//
//        guard var i = self.baseAddress,
//              var j = other.baseAddress else { fatalError() }
//
//        for _ in 0..<other.count {
//            let new = j.pointee
//            nonzeroBitCount += new.nonzeroBitCount
//            i.pointee = new
//
//            i = i.successor()
//            j = j.successor()
//        }
//        return nonzeroBitCount
//    }

//    func zero(
//        offset: Int
//    ) {
//        fatalError()
//    }

    func bitCopy(
        _ other: UnsafeBufferPointer<Element>
    ) -> Int {
        fatalError()
    }


    @inlinable @inline(__always)
    func bitCopy(
        _ other: UnsafeBufferPointer<Element>,
        offset: Int
    ) -> Int {
        guard other.isSome else { return 0 }

        var nonzeroBitCount = 0

        let count = other.count - offset

        guard var i = self.baseAddress,
              var j = other.baseAddress else { fatalError() }

        i = i.advanced(by: offset)
        j = j.advanced(by: offset)

        for _ in 0..<count {
            let new = j.pointee
            nonzeroBitCount += new.nonzeroBitCount
            i.pointee = new

            i = i.successor()
            j = j.successor()
        }
        return nonzeroBitCount
    }

//    @inlinable @inline(__always)
//    mutating func bitCopy(
//        _ other: UnsafeBufferPointer<Element>,
//        count: Int
//    ) -> Int {
//        guard other.isSome, count > 0 else { return 0 }
//
//        var nonzeroBitCount = 0
//
//        guard var i = self.baseAddress,
//              var j = other.baseAddress else { fatalError() }
//
//        for _ in 0..<count {
//            let new = j.pointee
//            nonzeroBitCount += new.nonzeroBitCount
//            i.pointee = new
//
//            i = i.successor()
//            j = j.successor()
//        }
//        return nonzeroBitCount
//    }

    @inlinable @inline(__always)
    mutating func bitOp(
        _ a: UnsafeBufferPointer<Element>,
        _ b: UnsafeBufferPointer<Element>,
        count: Int,
        op: (Element, Element) -> Element
    ) -> Int  {
        guard a.isSome, b.isSome, count > 0 else { return 0 }

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

//    public func formUnion(_ other: UnsafeBufferPointer<Element>, count: Int) -> Int {
//        guard var a = self.baseAddress,
//              var b = other.baseAddress else { fatalError() }
//
//        var bitCount = 0
//        for _ in 0..<count {
//            let new = a.pointee | b.pointee
//            a = a.successor()
//            b = b.successor()
//            a.pointee = new
//            bitCount += new.nonzeroBitCount
//        }
//        return bitCount
//    }
//
//    public func formIntersection(_ other: UnsafeBufferPointer<Element>, count: Int) -> Int {
//        guard var a = self.baseAddress,
//              var b = other.baseAddress else { fatalError() }
//
//        var bitCount = 0
//        for _ in 0..<count {
//            let new = a.pointee & b.pointee
//            a = a.successor()
//            b = b.successor()
//            a.pointee = new
//            bitCount += new.nonzeroBitCount
//        }
//        return bitCount
//    }

//    func copy(_ other: )
}
