import Ext

public struct BitArray2: SetAlgebra, ExpressibleByArrayLiteral, Sequence {
    public private(set) var count: Int

    //    @usableFromInline
    private var inner: ContiguousArray<UInt64>

    public init(count: Int, inner: ContiguousArray<UInt64>) {
        self.count = 0
        self.inner = inner
    }
//}

//extension BitArray2: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int...) {
        self.init(elements)
    }
//}

//extension BitArray2 : SetAlgebra {

    public typealias Element = Int
    public typealias Block = UInt64

    public init() {
        self.init(count: 0, inner: [])
    }

    public init<S>(_ sequence: __owned S) where S : Sequence, Int == S.Element {
        self.init()

        guard let max = sequence.max() else { return }
        self.reserveCapacity(max + 1)
        sequence.forEach {
            _ = self.insert($0)
        }
    }

    @inline(__always)
    public var capacity: Int {
        self.inner.count
    }

    //    @inlinabl
//    @inline(__always)
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        //        self.inner.append(zeros: count)
        self.inner.append(contentsOf: repeatElement(0, count: count))
    }

    //    @inlinable
//    @inline(__always)
    mutating func reserveCapacity(for value: Element) {
        let a = value.blockCount(bitWidth: Block.bitWidth)
        self.reserveCapacity(a)
    }

    //    @inlinable
    @inline(__always)
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        try self.inner.withUnsafeBufferPointer(body)
    }

    //    @inlinable
    @inline(__always)
    public mutating func withUnsafeMutableBufferPointer<R>(
        _ body: (inout UnsafeMutableBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        try self.inner.withUnsafeMutableBufferPointer(body)
    }
    //
    //    @inlinable @inline(__always)
    //    public func withUnsafeBufferPointer<R>(
    //        _ body: (UnsafeBufferPointer<UInt64>
    //        ) throws -> R) rethrows -> R {
    //        fatalError()
    //    }

    //    mutating func formUnion(_ other: Self) {
    //        let (minCapacity, _) = self.capacity.order(other.capacity)
    //
    //        self.reserveCapacity(other.capacity)
    //        fatalError()
    ////
    ////        self.inner.withUnsafeMutableBufferPointer { dst in
    ////            other.inner.withUnsafeBufferPointer { src in
    ////                dst.formOr(src, count: minCapacity)
    ////                fatalError()
    ////            }
    ////        }
    //    }

    public func union(_ other: Self) -> Self {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(capacity: maxCapacity)

        var nonzeroBitCount = 0

        inner.push((self.inner | other.inner).tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })
        assert(inner.count == minCapacity)

        assert(other.inner[minCapacity...].isEmpty || self.inner[minCapacity...].isEmpty)

        inner.push(self.inner[minCapacity...].tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })

        //        assert(other.inner[minCapacity...].isEmpty)
        inner.push(other.inner[minCapacity...].tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })
        return Self(count: nonzeroBitCount, inner: inner)
    }

    public mutating func formUnion(
        _ other: __owned Self
    ) {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.order(other.capacity)

        self.reserveCapacity(other.capacity)

        var count = 0
        for i in 0..<minCapacity {
            let new = self.inner[i] | other.inner[i]
            self.inner[i] = new
            count += new.nonzeroBitCount
        }

        let tail = other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            self.inner[i] = new
            count += new.nonzeroBitCount
        }

        self.count = count
    }

    mutating public func formUnion1(_ other: Self) {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        self.reserveCapacity(other.capacity)

        let nonzeroBitCount = self.inner.withUnsafeMutableBufferPointer { self_ -> Int in
            other.inner.withUnsafeBufferPointer { other_ -> Int in
                var nonzeroBitCount = 0
                var i = self_.baseAddress!
                var j = other_.baseAddress!
                let otherCount = other_.count

                for _ in 0..<minCapacity {
                    let new = i.pointee | j.pointee
                    i.pointee = new
                    count += new.nonzeroBitCount

                    i = i.successor()
                    j = j.successor()
                }

                for _ in minCapacity..<otherCount {
                    let new = j.pointee

                    i.pointee = new
                    nonzeroBitCount += new.nonzeroBitCount

                    i = i.successor()
                    j = j.successor()
                }

                return nonzeroBitCount
                //                _ = self_.initialize(from: (self_ | other_).tee {
                //                    nonzeroBitCount += $0.nonzeroBitCount
                //                })
                //                _ = self_.advanced(by: minCapacity).initialize(from: other_.advanced(by: minCapacity).tee {
                //                    nonzeroBitCount += $0.nonzeroBitCount
                //                })
                //                memcpy(<#T##__dst: UnsafeMutableRawPointer!##UnsafeMutableRawPointer!#>, <#T##__src: UnsafeRawPointer!##UnsafeRawPointer!#>, <#T##__n: Int##Int#>)
                //                memcpy(self_.baseAddress!, other_.baseAddress!, other.count)
                //                _ = self_.initialize(from: other_)
                //                _ = self_.advanced(by: minCapacity).initialize(from: other_)
            }
        }
        self.count = nonzeroBitCount
    }

    public func intersection(_ other: Self) -> Self {
        let (minCapacity, _) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(capacity: minCapacity)

        var nonzeroBitCount = 0
        inner.push((self.inner & other.inner).tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })
        assert(inner.count == minCapacity)

        return Self(count: nonzeroBitCount, inner: inner)
    }

    mutating public func formIntersection(_ other: Self) {
        let (minCapacity, _) = self.capacity.order(other.capacity)

        self.count = self.withUnsafeMutableBufferPointer { dst in
            other.withUnsafeBufferPointer { src in
                defer {
                    //                    dst.zero(offset: minCapacity)
                    dst.advanced(by: minCapacity).zeroAll()
                }
                return dst.bitOp(src, count: minCapacity, op: &)
            }
        }
    }

    public func symmetricDifference(_ other: Self) -> Self {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(capacity: maxCapacity)

        var nonzeroBitCount = 0
        inner.push((self.inner ^ other.inner).tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })
        assert(inner.count == minCapacity)

        inner.push(self.inner[minCapacity...].tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })

        inner.push(other.inner[minCapacity...].tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })
        assert(inner.count == maxCapacity)
        return Self(count: nonzeroBitCount, inner: inner)
    }

    public func formSymmetricDifference(_ other: Self) {
        fatalError()
    }

    public func subtract(_ other: Self) {
        fatalError()
    }

    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    public func contains(_ member: Element) -> Bool {
        fatalError()
    }

    public func remove(_ member: Element) -> Element? {
        fatalError()
    }

    public func update(with newMember: Element) -> Element? {
        fatalError()
    }


    @inlinable @inline(__always)
    func ratio(for member: Int) -> Ratio<Int> {
        member.ratio(Block.bitWidth)
    }

    //    @inlinable @inline(__always)
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        self.reserveCapacity(for: newMember)

        let ratio = self.ratio(for: newMember)
        let contains = self.inner[ratio]
        guard !contains else { return (false, newMember) }
        self.inner[ratio] = true
        self.count += 1
        return (true, newMember)
    }
//}

//extension BitArray2 : Sequence {
    public func makeIterator() -> BitArrayIterator {
        let bitCount = self.count
        return self.withUnsafeBufferPointer {
            BitArrayIterator(ptr: $0, nonzeroBitCount: bitCount)
        }
    }

    public var underestimatedCount: Int {
        self.count
    }
}
