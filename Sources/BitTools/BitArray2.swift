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

struct BitArray2 {
    public private(set) var count: Int
    var inner: ContiguousArray<UInt64>

    init(count: Int, inner: ContiguousArray<UInt64>) {
        fatalError()
    }
}

extension BitArray2: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int...) {
        fatalError()
    }
}


extension BitArray2 : SetAlgebra {
    public typealias Element = Int

    init() {
        fatalError()
    }

    init<S>(_ sequence: __owned S) where S : Sequence, Int == S.Element {
        fatalError()
    }

    var capacity: Int {
        fatalError()
    }

    func reserveCapacity(_ minimumCapacity: Int) {

    }

    @inlinable @inline(__always)
    public func withUnsafeMutableBufferPointer<R>(
        _ body: (UnsafeMutableBufferPointer<UInt64>
    ) throws -> R) rethrows -> R {
        fatalError()
    }

    @inlinable @inline(__always)
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        fatalError()
    }

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

    func union(_ other: Self) -> Self {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        let count =
        inner.withUnsafeMutableBufferPointer { dst in
            self.withUnsafeBufferPointer { a in
                other.withUnsafeBufferPointer { b in
                    dst.bitOp(a, b, count: minCapacity, op: |) +
                    dst.bitCopy(a, offset: minCapacity) +
                    dst.bitCopy(b, offset: minCapacity)
                }
            }
        }

//        inner.withUnsafeMutableBufferPointer { dst in
//            self.withUnsafeBufferPointer { a in
//                other.withUnsafeBufferPointer { b in
//                    dst.initialize(from: a | b)
////
////                    dst[..<minCapacity] = a[..<minCapacity] | b[..<minCapacity]
////                    dst[minCapacity...] = a[minCapacity...]
////                    dst[minCapacity...] = b[minCapacity...]
////                    dst.bitOp(a, b, count: minCapacity, op: |) +
////                    dst.bitCopy(a, offset: minCapacity) +
////                    dst.bitCopy(b, offset: minCapacity)
//                }
//            }
//        }

        var offset = 0
        var nonzeroBitCount = 0

//        offset += inner.append(contentsOf: inner | inner) {
//            nonzeroBitCount += $0.nonzeroBitCount
//        }

        offset += inner.append(contentsOf: self.inner[offset...]) {
            nonzeroBitCount += $0.nonzeroBitCount
        }

        offset += inner.append(contentsOf: other.inner[offset...]) {
            nonzeroBitCount += $0.nonzeroBitCount
        }

        return Self(count: nonzeroBitCount, inner: inner)
    }


    mutating func formUnion(_ other: Self) {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        self.reserveCapacity(maxCapacity)

        self.count = self.withUnsafeMutableBufferPointer { dst in
            other.withUnsafeBufferPointer { src in
                dst.bitOp(src, count: minCapacity, op: |) +
                dst.bitCopy(src, offset: minCapacity)
            }
        }
    }

    func intersection(_ other: Self) -> Self {
        let (minCapacity, _) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(zeros: minCapacity)

        let count =
        inner.withUnsafeMutableBufferPointer { dst in
            self.withUnsafeBufferPointer { a in
                other.withUnsafeBufferPointer { b in
                    dst.bitOp(a, b, count: minCapacity, op: &)
                }
            }
        }

        return Self(count: count, inner: inner)
    }

    mutating func formIntersection(_ other: Self) {
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

    func symmetricDifference(_ other: Self) -> Self {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(zeros: maxCapacity)

        let count =
        inner.withUnsafeMutableBufferPointer { dst in
            self.withUnsafeBufferPointer { a in
                other.withUnsafeBufferPointer { b in
                    dst.bitOp(a, b, count: minCapacity, op: ^) +
                    dst.advanced(by: minCapacity).bitCopy(a.advanced(by: minCapacity))
//                    dst.bitCopy(a, offset: minCapacity) +
//                    dst.bitCopy(b, offset: minCapacity)
                }
            }
        }

        return Self(count: count, inner: inner)
    }

    func formSymmetricDifference(_ other: Self) {
        fatalError()
    }

    func subtract(_ other: Self) {
        fatalError()
    }

    func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    func contains(_ member: Element) -> Bool {
        fatalError()
    }

    func remove(_ member: Element) -> Element? {
        fatalError()
    }

    func update(with newMember: Element) -> Element? {
        fatalError()
    }

    func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }
}
