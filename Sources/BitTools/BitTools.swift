public struct BitIterator<T: FixedWidthInteger> {
    var value: T

    init(value: T) {
        self.value = value
    }
}

extension BitIterator : IteratorProtocol {
    public typealias Element = Int

    public mutating func next() -> Element? {
        guard value.nonzeroBitCount != 0 else { return nil }
        let trailing = self.value.trailingZeroBitCount

        defer {
            _ = self.value.removeBit(T(exactly: trailing)!)
        }
        return trailing
    }
}

public struct BitSequence<T: FixedWidthInteger> {
    var value: T
}

extension BitSequence : Sequence {
    public func makeIterator() ->  BitIterator<T> {
        BitIterator(value: self.value)
    }
}

extension UnsafeBufferPointer {
    func withMemoryReboundToUInt64() -> UnsafeBufferPointer<UInt64> {
        fatalError()
    }
}

public struct BitPtrIterator {
    var ptr: UnsafePointer<UInt64>
    let blockCapacity: Int
    var blockIndex: Int
    var iterator: BitIterator<UInt64>

    public init(ptr: UnsafeBufferPointer<Bool>) {
        let elementByteSize = MemoryLayout<Bool>.size
        let byteSize = ptr.count * elementByteSize
        let blockSize = MemoryLayout<UInt64>.size
        assert(byteSize % blockSize == 0)
        let blockCapacity = byteSize / blockSize
        let ptr = ptr.baseAddress!.withMemoryRebound(to: UInt64.self, capacity: blockCapacity) { ptr in
            ptr
        }
        self.ptr = ptr
        self.blockCapacity = blockCapacity
        self.blockIndex = 0
        self.iterator = BitIterator(value: ptr[0])
    }
}

extension BitPtrIterator : IteratorProtocol {
    public typealias Element = Int

    mutating public func next() -> Element? {
        while true {
            if let nxt = self.iterator.next() {
                return nxt
            } else {
                guard self.blockIndex + 1 < self.blockIndex else { return nil }
                self.blockIndex += 1
                self.iterator = BitIterator(value: self.ptr[self.blockIndex])
            }
        }
    }
}

