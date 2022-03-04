public struct BoolArray {
    public private(set) var count: Int
    private var inner: ContiguousArray<Bool>

    public init(count: Int, inner: ContiguousArray<Bool>) {
        self.count = count
        self.inner = inner
    }

    public init() {
        self.init(count: 0, inner: [])
    }

    public init<S>(
        _ sequence: __owned S
    ) where S: Sequence, Int == S.Element {
        self.init()
        guard let max = sequence.max() else { return }
        self.reserveCapacity(max + 1)
        sequence.forEach {
            _ = self.insert($0)
        }
    }

    public init(arrayLiteral elements: Int...) {
        self.init(elements)
    }
}

extension BoolArray {

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

extension BoolArray: Sequence {
    public typealias Element = Int

    public func makeIterator() -> AnyIterator<Element> {
        var seen = 0
        var i = self.inner.enumerated().makeIterator()
        return AnyIterator {
            while
                let (idx, value) = i.next(),
                seen < self.count,
                value {

                seen += 1
                return idx
            }
            return nil
        }
    }

    public subscript(index: Int) -> Bool {
        get {
            self.inner[index]
        }
        set {
            count += self.inner[index].diff(newValue)
            self.inner[index] = newValue
        }
    }
}

extension BoolArray {
    public mutating func removeAll() {
        self.count = 0
        self.inner.falseAll()
    }

    public mutating func removeAll(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows {
        for index in 0..<self.inner.count {
            if try self[index] && shouldBeRemoved(index) {
                self.inner[index] = false
                self.count -= 1
            }
        }
    }

    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        let count = minimumCapacity - self.inner.count
        guard count > 0 else { return }
        self.inner.append(false: count)
    }
}

extension BoolArray: SetAlgebra {
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
            let oldValue = self.inner[i]
            let newValue = self.inner[i] || other.inner[i]

            self.inner[i] = newValue
            count += oldValue.diff(newValue)
        }

        let tail = other.inner[minCapacity...]

        for i in minCapacity..<maxCapacity {
            let new = tail[i]
            self.inner[i] = new
            count += Int(new)
        }

        self.count += count
    }

    public func intersection(_ other: Self) -> Self {
        let capacity = Swift.min(self.capacity, other.capacity)

        var count = 0
        var inner = ContiguousArray<Bool>(false: capacity)

        for i in 0..<capacity {
            let new = self.inner[i] && other.inner[i]
            count += Int(new)
            inner[i] = new
        }

        return Self(
            count: count,
            inner: inner
        )
    }

    public mutating func formIntersection(_ other: Self) {
        let capacity = Swift.min(self.capacity, other.capacity)

        for i in 0..<capacity {
            let oldValue = self[i]
            let newValue = oldValue && other[i]
            self[i] = newValue
            self.count += newValue.diff(oldValue)
        }
    }

    public func symmetricDifference(_ other: Self) -> Self {
        let (
            minCapacity,
            maxCapacity
        ) = self.capacity.extrema(other.capacity)

        var count = 0
        var inner = ContiguousArray<Bool>(false: maxCapacity)

        for i in 0..<minCapacity {
            let new = self.inner[i].xor(other.inner[i])
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

    public mutating func formSymmetricDifference(_ other: Self) {
        let capacity = Swift.min(self.capacity, other.capacity)

        for i in 0..<capacity {
            self.inner[i] = self.inner[i].xor(other.inner[i])
        }

        fatalError()
    }

    public mutating func insert(
        _ newMember: Int
    ) -> (inserted: Bool, memberAfterInsert: Int) {
        guard !self.contains(newMember) else { return (false, newMember) }
        self.count += 1
        self.inner[newMember] = true
        return (true, newMember)
    }

    public mutating func update(with newMember: Int) -> Int? {
        if self.insert(newMember).inserted {
            return newMember
        } else {
            return nil
        }
    }

    public func contains(_ member: Int) -> Bool {
        self.inner[member]
    }

    public mutating func remove(_ member: Int) -> Int? {
        guard self.contains(member) else { return nil }
        self.count -= 1
        self.inner[member] = false
        return member
    }

    public mutating func subtract(_ other: Self) {
        fatalError()
    }

    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }
}

extension BoolArray: CustomStringConvertible {
    public var description: String {
        "BoolArray(\(Array(self)))"
    }
}
