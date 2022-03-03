public struct BitIterator<T: FixedWidthInteger> {
    private var value: T
    private var remaining: Int


    public init(_ value: T) {
        self.value = value
        self.remaining = value.nonzeroBitCount
    }
}

extension BitIterator: IteratorProtocol {
    public typealias Element = Int

    public mutating func next() -> Element? {
        guard self.remaining > 0 else { return nil }
        let trailing = self.value.trailingZeroBitCount

        defer {
            self.remaining -= 1
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
