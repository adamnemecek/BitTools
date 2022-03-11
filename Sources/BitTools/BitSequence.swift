extension UnsafeBufferPointer where Element == UInt64 {
    func nonzeroBitCount() -> Int {
        guard var ptr = self.baseAddress else { return 0 }
        var remaining = self.count
        var sum = 0
        while remaining > 0 {
            sum += ptr.pointee.nonzeroBitCount
            ptr = ptr.successor()
            remaining -= 1
        }
        return sum
    }
}

@frozen
public struct BitArrayIterator {
    public typealias Element = Int

    private var ptr: UnsafePointer<UInt64>

    ///
    /// how many blocks total
    ///
    private let blockCount: Int

    ///
    /// how many bits were the at the beginning
    ///
    //    private let nonzeroBitCount: Int
    ///
    /// how many nonzero bitcounts are there
    ///
    private var remainingNonzeroBitCount: Int
    ///
    /// index of the block we are processing
    ///
    private var blockIndex: Int
    ///
    /// the current block we are iterating
    ///
    private var block: UInt64
    ///
    /// how many blocks have we seen so far (in bits)
    ///
    private var bitBlockOffset: Int
}

extension BitArrayIterator: IteratorProtocol {
    //    @inlinable
    @inline(__always)
    public init(ptr: UnsafeBufferPointer<UInt64>, nonzeroBitCount: Int) {
        guard let p = ptr.baseAddress else { fatalError() }

        self.init(
            ptr: p,
            blockCount: ptr.count,
            //            nonzeroBitCount: nonzeroBitCount,
            remainingNonzeroBitCount: nonzeroBitCount,
            blockIndex: 0,
            block: p.pointee,
            bitBlockOffset: 0
        )
    }
    //
    //    public var underestimatedCount: Int {
    //        fatalError()
    //    }

    //    @inlinable
    @inline(__always)
    public mutating func next() -> Element? {
        while self.block == 0 {
            self.blockIndex += 1
            if self.remainingNonzeroBitCount == 0 || self.blockIndex == self.blockCount {
                return nil
            }

            self.ptr = self.ptr.successor()
            self.block = self.ptr.pointee
            self.bitBlockOffset += UInt64.bitWidth
        }

        self.remainingNonzeroBitCount -= 1
        let trailing = block.trailingZeroBitCount
        self.block &= ~(1 << trailing)
        return self.bitBlockOffset + trailing
    }
}

// iterates with value
struct BitArrayIterator2 {
    private var ptr: UnsafePointer<UInt64>

    ///
    /// how many blocks total
    ///
    private let blockCount: Int

    ///
    /// how many bits were the at the beginning
    ///
    //    private let nonzeroBitCount: Int
    ///
    /// how many nonzero bitcounts are there
    ///
    private var remainingNonzeroBitCount: Int
    ///
    /// index of the block we are processing
    ///
    private var blockIndex: Int
    ///
    /// the current block we are iterating
    ///
    private var block: UInt64
    ///
    /// how many blocks have we seen so far (in bits)
    ///
    private var bitBlockOffset: Int
}

extension BitArrayIterator2: IteratorProtocol {
    init(ptr: UnsafeBufferPointer<UInt64>, nonzeroBitCount: Int) {
        guard let p = ptr.baseAddress else { fatalError() }

        self.init(
            ptr: p,
            blockCount: ptr.count,
            //            nonzeroBitCount: nonzeroBitCount,
            remainingNonzeroBitCount: nonzeroBitCount,
            blockIndex: 0,
            block: p.pointee,
            bitBlockOffset: 0
        )
    }

    var underestimatedCount: Int {
        fatalError()
    }

    @inline(__always)
    mutating func next() -> (value: Int, index: BitIndex)? {
        while self.block == 0 {
            self.blockIndex  += 1
            if self.remainingNonzeroBitCount == 0 || self.blockIndex == self.blockCount {
                return nil
            }

            self.ptr = self.ptr.successor()
            self.block = self.ptr.pointee
            self.bitBlockOffset += UInt64.bitWidth
        }

        self.remainingNonzeroBitCount -= 1
        let trailing = block.trailingZeroBitCount
        self.block &= ~(1 << trailing)
        let value = self.bitBlockOffset + trailing
        return (value, BitIndex(self.blockIndex, trailing, value))
    }
}

// func test() {
//    var a = [1,2,3,4]
//
//    var i = a.makeIterator()
// }
extension UnsafeBufferPointer where Element == UInt64 {
    // this one is not counted unlike the other one
    @frozen
    public struct BitIterator: IteratorProtocol {
        public typealias Element = Int

        @usableFromInline
        internal var ptr: UnsafePointer<UInt64>

        ///
        /// how many blocks total
        ///
        @usableFromInline
        internal let blockCount: Int

        ///
        /// how many bits were the at the beginning
        ///
        //    private let nonzeroBitCount: Int
        ///
        /// how many nonzero bitcounts are there
        ///
        //    private var remainingNonzeroBitCount: Int
        ///
        /// index of the block we are processing
        ///
        @usableFromInline
        internal var blockIndex: Int
        ///
        /// the current block we are iterating
        ///
        @usableFromInline
        internal var block: UInt64
        ///
        /// how many blocks have we seen so far (in bits)
        ///
        @usableFromInline
        internal var bitBlockOffset: Int

        @inlinable
        @inline(__always)
        public init(ptr: UnsafeBufferPointer<UInt64>) {
            guard let p = ptr.baseAddress else { fatalError() }

            self.ptr = p
            self.blockCount = ptr.count
            self.blockIndex = 0
            self.block = p.pointee
            self.bitBlockOffset = 0
        }

        @inlinable
        @inline(__always)
        public mutating func next() -> Element? {
            while self.block == 0 {
                self.blockIndex += 1
                if self.blockIndex == self.blockCount {
                    return nil
                }

                self.ptr = self.ptr.successor()
                self.block = self.ptr.pointee
                self.bitBlockOffset += UInt64.bitWidth
            }

            let trailing = block.trailingZeroBitCount
            self.block &= ~(1 << trailing)
            return self.bitBlockOffset + trailing
        }
    }

    public func makeBitIterator() -> BitIterator {
        BitIterator(ptr: self)
    }
}
