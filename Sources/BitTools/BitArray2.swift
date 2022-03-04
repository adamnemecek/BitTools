
struct BitArray2 {
    public private(set) var count: Int
    var inner: ContiguousArray<Bool>
}

extension BitArray2 {
    public init() {
        self.count = 0
        self.inner = []
    }

    public var isEmpty: Bool {
        self.count != 0
    }

    public var underestimatedCount: Int {
        self.count
    }
}

extension BitArray2: Sequence {
    public typealias Element = Int

    public func makeIterator() -> AnyIterator<Element> {
        var seen = 0
        var i = self.inner.enumerated().makeIterator()
        return AnyIterator {
            while let (idx, value) = i.next(), seen < self.count {
                if value {
                    seen += 1
                    return idx
                }
            }
            return nil
        }
    }

    subscript(index: Int) -> Bool {
        get {
            self.inner[index]
        }
        set {
            // update count
            self.inner[index] = newValue
        }
    }
}

extension BitArray2 {
    public mutating func removeAll(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows {
        for index in 0..<self.inner.count {
            if try shouldBeRemoved(index) {
                self.inner[index] = false
                self.count -= 1
            }
        }
    }
}


extension BitArray2: SetAlgebra {
    public func union(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formUnion(_ other: Self) {
        fatalError()
    }

    public func intersection(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formIntersection(_ other: Self) {
        fatalError()
    }

    public func symmetricDifference(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formSymmetricDifference(_ other: Self) {
        fatalError()
    }

    public mutating func insert(_ newMember: Int) -> (inserted: Bool, memberAfterInsert: Int) {
        defer {
            self.inner[newMember] = true
        }
        return (self.inner[newMember], newMember)
    }

    public func update(with newMember: Int) -> Int? {
        fatalError()
    }

    public func contains(_ member: Int) -> Bool {
        self.inner[member]
    }

    public func remove(_ member: Int) -> Int? {
        fatalError()
    }
}

