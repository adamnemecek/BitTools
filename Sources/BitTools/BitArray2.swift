import Ext

public struct BitArray2 {
    var inner: ContiguousArray<UInt64>
}

extension BitArray2 {
    var capacity: Int {
        fatalError()
    }

    func reserveCapacity(_ minimumCapacity: Int) {

    }

    @inline(__always)
    public func withUnsafeMutableBufferPointer<R>(
        _ body: (UnsafeMutableBufferPointer<UInt64>
    ) throws -> R) rethrows -> R {
        fatalError()
    }

    @inline(__always)
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt64>
        ) throws -> R) rethrows -> R {
        fatalError()
    }

    mutating func formUnion(_ other: Self) {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)

        self.reserveCapacity(other.capacity)

        self.inner.withUnsafeMutableBufferPointer { dst in
            other.inner.withUnsafeBufferPointer { src in
                dst.formOr(src, count: minCapacity)
                fatalError()
            }
        }
    }

    func union(_ other: Self) -> Self {
        let (minCapacity, maxCapacity) = self.capacity.order(other.capacity)
        var inner = ContiguousArray<UInt64>(zeros: Swift.max(self.capacity, other.capacity))

        let a = inner.withUnsafeMutableBufferPointer { dst in
            self.inner.withUnsafeBufferPointer { a in
                other.inner.withUnsafeBufferPointer { b in
                    10
//                    dst.bitOp(a, b, count: minCapacity, op: |) +
//                    dst.bitCopy(a.advance, count: |)

//                    dst.bitCopy(b, count: |)
                }
            }
        }

        fatalError()
    }
}
