

@inline(__always)
func blockIndex(_ value: Int) -> BlockIndex {
    // 2^6 = 64
    let blockIndex = value >> 6

    let ret = BlockIndex(
        blockIndex,
        value - (blockIndex << 6),
        value
    )

    assert(ret.recalculatedValue == value)
    return ret
}

// this is a divrem with 64
@usableFromInline
@frozen
struct BlockIndex: Equatable {
    let blockIndex: Int
    let bitIndex: Int
    let value: Int

    @inline(__always)
    init(_ blockIndex: Int, _ bitIndex: Int, _ value: Int) {
        self.blockIndex = blockIndex
        self.bitIndex = bitIndex
        self.value = value
    }

    @inline(__always)
    init(_ value: Int) {
        self = BitTools.blockIndex(value)
//        // 2^6 = 64
//        let blockIndex = value >> 6
//
//        self.init(
//            blockIndex,
//            value - (blockIndex << 6)
//        )
//
//        assert(self.value == value)
    }

    var recalculatedValue: Int {
        self.blockIndex << 6 + self.bitIndex
    }

    var blocksNeeded: Int {
        Int((value + 1).roundUp(to: UInt64.bitWidth) / UInt64.bitWidth)
    }

//    var blocksNeeded2: Int {
//        let block = BitTools.blockIndex(self.value + 1)
//        // bitindex is modulo
//        if block.bitIndex == 0 {
//            return block.blockIndex
//        } else {
//            return block.value - block.
//        }
//    }
}

//extension Int {
//    func roundUp64() -> Self {
//        let m = self - self
//    }
//}