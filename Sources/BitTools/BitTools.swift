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
