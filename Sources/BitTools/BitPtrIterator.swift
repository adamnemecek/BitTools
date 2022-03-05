

// doesnt' know the

struct BitPtrIterator {
    let ptr: UnsafeBufferPointer<UInt64>
    var blockOffset: Int

    var bitBlockOffset: Int
//    var bitIterator: BitIterator(fst)

    init(
        ptr: UnsafeBufferPointer<UInt64>
    ) {
        self.ptr = ptr
        self.blockOffset = 0
        self.bitBlockOffset = 0
//        self.bitIterator = Bit
        fatalError()

    }
}


extension BitPtrIterator : IteratorProtocol {
    public typealias Element = Int
    public func next() -> Element? {
        while true {

        }
        fatalError()
    }
}
