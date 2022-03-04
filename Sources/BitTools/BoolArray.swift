
struct BitArray2 {
    public private(set) var count: Int
    var inner: ContiguousArray<Bool>

    public init(count: Int, inner: ContiguousArray<Bool>) {
        self.count = count
        self.inner = inner
    }

    public init() {
        self.init(count: 0, inner: [])
    }
}

extension BitArray2 {

    public var isEmpty: Bool {
        self.count != 0
    }

    public var underestimatedCount: Int {
        self.count
    }

    public var capacity: Int {
        self.inner.count
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
            count += self.inner[index].diff(newValue)
            self.inner[index] = newValue
        }
    }
}

extension BitArray2 {
    public mutating func removeAll(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows {
        for index in 0..<self.inner.count  {
            if try self[index] && shouldBeRemoved(index) {
                self.inner[index] = false
                self.count -= 1
            }
        }
    }

    mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        self.inner.append(false: count)
    }
}


extension BitArray2: SetAlgebra {
    public func union(_ other: Self) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        var count = 0
        var inner = ContiguousArray<Bool>(false: maxCapacity)

        for i in 0..<minCapacity {
            let new = self.inner[i] || other.inner[i]
            count += Int(new)
            inner[i] = new
        }

        let tail = self.inner[minCapacity...] ??
                    other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            inner[i] = new
            count += Int(new)
        }
        return Self(count: count, inner: inner)

    }

    public mutating func formUnion(_ other: Self) {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        self.reserveCapacity(other.capacity)

        var count = 0
        for i in 0..<minCapacity {
            let new = self.inner[i] || other.inner[i]
            self.inner[i] = new
            count += Int(new)
        }

        let tail = other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            self.inner[i] = new
            count += Int(new)
        }

        self.count = count
    }

    public func intersection(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formIntersection(_ other: Self) {
        let capacity = Swift.min(self.capacity, other.capacity)

        var count = 0
        for i in 0..<capacity {
            self[i] = self[i] && other[i]
            count += Int(self[i])
        }
        self.count = count
    }

    public func symmetricDifference(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formSymmetricDifference(_ other: Self) {
        fatalError()
    }

    public mutating func insert(
        _ newMember: Int
    ) -> (inserted: Bool, memberAfterInsert: Int) {
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
