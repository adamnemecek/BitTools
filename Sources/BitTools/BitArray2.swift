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

        return Self(count: count, inner: inner)
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

    func intersection(_ other: BitArray2) -> BitArray2 {
        fatalError()
    }

    func formIntersection(_ other: BitArray2) {
        fatalError()
    }

    func symmetricDifference(_ other: BitArray2) -> BitArray2 {
        fatalError()
    }

    func formSymmetricDifference(_ other: BitArray2) {
        fatalError()
    }

    func subtract(_ other: BitArray2) {
        fatalError()
    }

    func subtracting(_ other: BitArray2) -> BitArray2 {
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
