import Ext


//extension Comparable {
//
//
//    func min(_ other: Self) -> Self {
//        Swift.min(self, other)
//    }
//
//    func max(_ other: Self) -> Self {
//        Swift.max(self, other)
//    }
//}

public struct BitArray2 {
    public private(set) var count: Int

    @usableFromInline
    var inner: ContiguousArray<UInt64>

    public init(count: Int, inner: ContiguousArray<UInt64>) {
        self.count = 0
        self.inner = inner
    }
}

extension BitArray2: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int...) {
        self.init(elements)
    }
}

extension BitArray2 : SetAlgebra {

    public typealias Element = Int

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

    @inlinable @inline(__always)
    public var capacity: Int {
        self.inner.count
    }

    @inlinable @inline(__always)
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.count
        guard count > 0 else { return }
        self.inner.append(zeros: count)
    }

    @inlinable @inline(__always)
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        try self.inner.withUnsafeBufferPointer(body)
    }

    @inlinable @inline(__always)
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

        assert(self.inner[minCapacity...].isEmpty)
        inner.push(self.inner[minCapacity...].tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })

        assert(other.inner[minCapacity...].isEmpty)
        inner.push(other.inner[minCapacity...].tee {
            nonzeroBitCount += $0.nonzeroBitCount
        })
        return Self(count: nonzeroBitCount, inner: inner)
    }


    mutating public func formUnion(_ other: Self) {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        self.reserveCapacity(maxCapacity)

        var nonzeroBitCount = 0
        self.withUnsafeMutableBufferPointer { self_ in
            other.withUnsafeBufferPointer { other_ in
                _ = self_.initialize(from: (self_ | other_).tee {
                    nonzeroBitCount += $0.nonzeroBitCount
                })
                _ = self_.advanced(by: minCapacity).initialize(from: other_.advanced(by: minCapacity).tee {
                    nonzeroBitCount += $0.nonzeroBitCount
                })
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

    public func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }
}

extension BitArray2 : Sequence {
    public func makeIterator() -> BitArrayIterator {
        fatalError()
    }

    public var underestimatedCount: Int {
        self.count
    }
}
