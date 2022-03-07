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

public struct BitArrayIterator {
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
//
//    public var underestimatedCount: Int {
//        fatalError()
//    }

    @inline(__always)
    public mutating func next() -> Int? {
        while self.block == 0 {
            self.blockIndex += 1
            if self.remainingNonzeroBitCount == 0 || self.blockIndex == self.blockCount {
                return nil
            }

            self.ptr = self.ptr.successor()
            block = self.ptr.pointee
            bitBlockOffset += UInt64.bitWidth
        }

        self.remainingNonzeroBitCount -= 1
        let trailing = block.trailingZeroBitCount
        self.block &= ~(1 << trailing)
        return self.bitBlockOffset + trailing
    }
}

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
    mutating func next() -> (value: Int, index: BlockIndex)? {
        while self.block == 0 {
            self.blockIndex  += 1
            if self.remainingNonzeroBitCount == 0 || self.blockIndex == self.blockCount {
                return nil
            }

            self.ptr = self.ptr.successor()
            block = self.ptr.pointee
            bitBlockOffset += UInt64.bitWidth
        }

        self.remainingNonzeroBitCount -= 1
        let trailing = block.trailingZeroBitCount
        self.block &= ~(1 << trailing)
        return (self.bitBlockOffset + trailing, BlockIndex(self.blockIndex, trailing))
    }
}


//func test() {
//    var a = [1,2,3,4]
//
//    var i = a.makeIterator()
//}
