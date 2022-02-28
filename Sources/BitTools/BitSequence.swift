public struct BitIterator<T: FixedWidthInteger> {
    var value: T

    public init(_ value: T) {
        self.value = value
    }
}

extension BitIterator: IteratorProtocol {
    public typealias Element = Int

    public mutating func next() -> Element? {
        guard value.nonzeroBitCount != 0 else { return nil }
        let trailing = self.value.trailingZeroBitCount

        defer {
            self.value.remove(bit: T(exactly: trailing)!)
        }
        return trailing
    }
}

public struct BitSequence<T: FixedWidthInteger> {
    let value: T

    public init(_ value: T) {
        self.value = value
    }
}

extension BitSequence: Sequence {
    public func makeIterator() ->  BitIterator<T> {
        BitIterator(self.value)
    }
}
