

struct BitArrayTestHarness<S>: SetAlgebra, Sequence where S: SetAlgebra & Sequence, S.Element == Int {
    typealias Element = Int

    typealias ArrayLiteralElement = Element


    var set: Set<Int>
    var array: S

    init() {

        self.set = []
        self.array = []
    }

    init(_ set: Set<Int>, _ array: S) {
        self.set = set
        self.array = array
    }

    func check() -> Bool {
        let sorted = self.set.sorted()
        return sorted.elementsEqual(self.array)
    }

    func union(_ other: Self) -> Self {
        Self(
            self.set.union(other.set),
            self.array.union(other.array)
        )
    }

    mutating func formUnion(_ other: Self) {
        self.set.formUnion(other.set)
        self.array.formUnion(other.array)
    }

    func intersection(_ other: Self) -> Self {
        Self(
            self.set.intersection(other.set),
            self.array.intersection(other.array)
        )
    }

    mutating func formIntersection(_ other: Self) {
        self.set.formIntersection(other.set)
        self.array.formIntersection(other.array)
    }


    func symmetricDifference(_ other: Self) -> Self {
        Self(
            self.set.symmetricDifference(other.set),
            self.array.symmetricDifference(other.array)
        )
    }

    mutating func formSymmetricDifference(_ other: Self) {
        self.set.formSymmetricDifference(other.set)
        self.array.formSymmetricDifference(other.array)
    }

    func subtracting(_ other: Self) -> Self {
        Self(
            self.set.subtracting(other.set),
            self.array.subtracting(other.array)
        )
    }

    mutating func subtract(_ other: Self) {
        self.set.subtract(other.set)
        self.array.subtract(other.array)
    }

    mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let a = self.set.insert(newMember)
        let b = self.array.insert(newMember)
        assert(a == b)
        return a
    }

    mutating func update(with newMember: Element) -> Element? {
        let a = self.set.update(with: newMember)
        let b = self.array.update(with: newMember)
        assert(a == b)
        return a
    }

    func contains(_ member: Element) -> Bool {
        let a = self.set.contains(member)
        let b = self.array.contains(member)
        assert(a == b)
        return a
    }

    mutating func remove(_ member: Element) -> Element? {
        let a = self.set.remove(member)
        let b = self.array.remove(member)
        assert(a == b)
        return a
    }

    func makeIterator() -> AnyIterator<Int> {
        var a = self.set.sorted().makeIterator()
        var b = self.array.makeIterator()
        return AnyIterator {
            let na = a.next()
            let nb = b.next()
            assert(na == nb)
            return na
        }
    }
}


