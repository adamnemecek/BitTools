extension UnsafeBufferPointer where Element == UInt64 {

    @frozen
    public struct OrBitIterator: IteratorProtocol {
        @usableFromInline
        internal var block: UInt64

        @usableFromInline
        internal var a: Iterator

        @usableFromInline
        internal var b: Iterator

        @inlinable @inline(__always)
        init(a: Iterator, b: Iterator) {
            self.a = a
            self.b = b
            self.block = 0
        }

        @inlinable @inline(__always)
        public mutating func next() -> UInt64? {
        loop:
            while true {
                if self.block == 0 {
                    switch (a.next(), b.next()) {
                    case let (.some(l), .some(r)):
                        self.block = l | r
                        continue loop
                    case let (nil, .some(r)):
                        self.block = r
                    case let (.some(l), nil):
                        self.block = l
                    case (nil, nil):
                        return nil
                    }
                }
            }
        }
    }

    @frozen
    public struct OrBitSequence: Sequence {
        @usableFromInline
        internal let a: UnsafeBufferPointer<UInt64>

        @usableFromInline
        internal let b: UnsafeBufferPointer<UInt64>

        @inlinable @inline(__always)
        init(a: UnsafeBufferPointer<UInt64>, b: UnsafeBufferPointer<UInt64>) {
            self.a = a
            self.b = b
        }

        @inlinable @inline(__always)
        public func makeIterator() -> OrBitIterator {
            OrBitIterator(a: a.makeIterator(), b: b.makeIterator())
        }
    }

    @inlinable @inline(__always)
    public static func |(lhs: Self, rhs: Self) -> OrBitSequence {
        OrBitSequence(a: lhs, b: rhs)
    }
}
