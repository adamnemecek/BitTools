import Foundation

// public func koremetalbundle() {
//    for b in Bundle.allFrameworks {
//        print(b)
//    }
// }
///
/// this stores data
///

/// this is a sparse bit array
/// that lets you iterate over a sparse array very quickyl
/// imagine a bitarray with 10000 values only 10 of which are set
/// 10000 bits = 156 uint64
/// an extra level will take up 156 / 64 = ~2.4 = 3 extra bits but will be much faster
/// to iterate and such
/// but if we use an extra level and say the values are only in three blocks
/// we can only ever deal with the blocks that have any values in them
///

// public struct SparseBitArray {
//    var meta: SparseBitArrayMeta
//    var inner: BitArray
// }

// extension SparseBitArray {
//
//    var capacity: Int {
//        self.inner.capacity
//    }
//
//    mutating func reserveCapacity(_ minimumCapacity: Int) {
//        let count = minimumCapacity - self.inner.count
//        guard count > 0 else { return }
////        self.inner.append(zeros: count)
//        fatalError()
//    }
//
//    var count: Int {
//        self.inner.count
//    }
//
//
// }

extension BitArray {
    @inline(__always) @inlinable
    subscript(block index: Int) -> UInt64 {
        get {
            self.inner[index]
        }
        set {
            self.inner[index] = newValue
        }
    }
}

extension BitArray {
    var meta: Meta {
        fatalError()
    }
}

public struct SparseBitArray: SetAlgebra, ExpressibleByArrayLiteral {
    public typealias Element = Int
    public typealias ArrayLiteralElement = Element

    var meta: Meta
    var inner: BitArray

    public init() {
        fatalError()
    }

    public init<S>(_ sequence: __owned S) where S: Sequence, Element == S.Element {
        fatalError()
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.meta == rhs.meta && lhs.inner == rhs.inner
    }

    public init(arrayLiteral elements: Element...) {
        fatalError()
    }

    public var isEmpty: Bool {
        self.inner.isEmpty
    }

    public var isSome: Bool {
        self.inner.isSome
    }

    public func contains(_ member: Element) -> Bool {
        self.inner.contains(member)
    }

    public __consuming func union(_ other: __owned Self) -> Self {
        fatalError()
    }

    public mutating func formUnion(_ other: __owned Self) {
        self.meta.formUnion(other.meta)
        self.inner.formUnion(other.inner)
    }

    public __consuming func intersection(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func formIntersection(_ other: Self) {
        self.meta.formUnion(other.meta)
        self.inner.formUnion(other.inner)
    }

    public __consuming func symmetricDifference(_ other: __owned Self) -> Self {
        fatalError()
    }

    public mutating func formSymmetricDifference(_ other: __owned Self) {
        fatalError()
    }

    public mutating func subtract(_ other: Self) {
        fatalError()
    }

    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }

    public mutating func remove(_ member: Element) -> Element? {
        if let value = self.inner.remove(member) {
            // update meta
        } else {
            // don't update meta
        }
        fatalError()
    }

    public mutating func update(with newMember: __owned Element) -> Element? {
        if let value = self.inner.update(with: newMember) {
            // no need to meta
            return value
        } else {
            fatalError()
            // update meta
            return nil
        }
    }

    public func isSubset(of other: Self) -> Bool {
        fatalError()
    }

    public func isSuperset(of other: Self) -> Bool {
        fatalError()
    }

    public func isDisjoint(with other: Self) -> Bool {
        fatalError()
    }

    public mutating func removeAll() {
        self.inner.removeAll()
        self.meta.removeAll()
    }
    //
    //    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    //        fatalError()
    //    }
}

extension SparseBitArray: Sequence {
    public func makeIterator() -> AnyIterator<Int> {
        fatalError()
    }
}

@usableFromInline
struct BlockIndex {
    @usableFromInline
    let index: Int
}

func meta(
    bitset: BitArray

) -> ContiguousArray<UInt64> {
    fatalError()
}


@usableFromInline
struct Meta: SetAlgebra, ExpressibleByArrayLiteral, Sequence {
    @usableFromInline
    typealias Element = BlockIndex

    @usableFromInline
    typealias ArrayLiteralElement = Element

    @usableFromInline
    var inner: BitArray

    // how many blocks can this accomodate
    var blockCapacity: Int {
        self.inner.count << 6
    }

    @inline(__always) @inlinable
    init() {
        self.inner = []
    }

    @inline(__always) @inlinable
    init<S>(_ sequence: __owned S) where S: Sequence, Element == S.Element {
        self.inner = []
        for e in sequence {
            _ = self.insert(e)
        }
    }

    @inline(__always) @inlinable
    init(inner: BitArray) {
        self.inner = inner
    }

    @inline(__always) @inlinable
    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    @inline(__always) @inlinable
    var isEmpty: Bool {
        self.inner.isEmpty
    }

    @inline(__always) @inlinable
    var isSome: Bool {
        self.inner.isSome
    }

    @inline(__always) @inlinable
    func contains(_ member: Element) -> Bool {
        self.inner.contains(member.index)
    }

    @inline(__always) @inlinable
    __consuming func union(_ other: __owned Self) -> Self {
        Self(
            inner: self.inner.union(other.inner)
        )
    }

    @inline(__always) @inlinable
    mutating func formUnion(_ other: __owned Self) {
        self.inner.formUnion(other.inner)
    }

    @inline(__always) @inlinable
    __consuming func intersection(_ other: Self) -> Self {
        Self(
            inner: self.inner.intersection(other.inner)
        )
    }

    @inline(__always) @inlinable
    mutating func formIntersection(_ other: Self) {
        self.inner.formIntersection(other.inner)
    }

    @inline(__always) @inlinable
    __consuming func symmetricDifference(_ other: __owned Self) -> Self {
        Self(
            inner: self.inner.symmetricDifference(other.inner)
        )
    }

    @inline(__always) @inlinable
    mutating func formSymmetricDifference(_ other: __owned Self) {
        self.inner.formSymmetricDifference(other.inner)
    }

    @inline(__always) @inlinable
    mutating func insert(
        _ newMember: __owned Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        (self.inner.insert(newMember.index).inserted, newMember)
    }

    @inline(__always) @inlinable
    mutating func remove(_ member: Element) -> Element? {
        self.inner.remove(member.index)
        fatalError()
    }

    @inline(__always) @inlinable
    mutating func update(with newMember: __owned Element) -> Element? {
        //        self.inner.update(newMember.blockIndex)
        fatalError()
    }

    @inline(__always) @inlinable
    mutating func subtract(_ other: Self) {
        self.inner.subtract(other.inner)
    }

    @inline(__always) @inlinable
    func subtracting(_ other: Self) -> Self {
        Self(
            inner: self.inner.subtracting(other.inner)
        )
    }

    @inline(__always) @inlinable
    func isSubset(of other: Self) -> Bool {
        self.inner.isSubset(of: other.inner)
    }

    @inline(__always) @inlinable
    func isSuperset(of other: Self) -> Bool {
        self.inner.isSuperset(of: other.inner)
    }

    @inline(__always) @inlinable
    func isDisjoint(with other: Self) -> Bool {
        self.inner.isDisjoint(with: other.inner)
    }

    @inline(__always) @inlinable
    mutating func removeAll() {
        self.inner.removeAll()
    }

    @inline(__always) @inlinable
    func makeIterator() -> AnyIterator<BlockIndex> {
        fatalError()
    }
}
