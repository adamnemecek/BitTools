import Foundation

//public func koremetalbundle() {
//    for b in Bundle.allFrameworks {
//        print(b)
//    }
//}
///
/// this stores data
///

/// this is a sparse bit array
/// that lets you iterate over a sparse array very quickyl
/// imagine a bitarray with 10000 values only 10 of which are set


//public struct SparseBitArray {
//    var meta: SparseBitArrayMeta
//    var inner: BitArray
//}

//extension SparseBitArray {
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
//}

struct SparseBitArray: SetAlgebra, ExpressibleByArrayLiteral {

    typealias Element = Int

    typealias ArrayLiteralElement = Element

    var meta: Meta
    var inner: BitArray

    init() {
        fatalError()
    }

    init<S>(_ sequence: __owned S) where S : Sequence, Int == S.Element {
        fatalError()
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        fatalError()
    }

    init(arrayLiteral elements: Element...) {
        fatalError()
    }

    var isEmpty: Bool {
        fatalError()
    }

    var isSome: Bool {
        fatalError()
    }

    func contains(_ member: Element) -> Bool {
        fatalError()
    }

    __consuming func union(_ other: __owned Self) -> Self {
        fatalError()
    }

    mutating func formUnion(_ other: __owned Self) {
        fatalError()
    }

    __consuming func intersection(_ other: Self) -> Self {
        fatalError()
    }

    mutating func formIntersection(_ other: Self) {
        fatalError()
    }

    __consuming func symmetricDifference(_ other: __owned Self) -> Self {
        fatalError()
    }

    mutating func formSymmetricDifference(_ other: __owned Self) {
        fatalError()
    }

    mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }

    mutating func remove(_ member: Element) -> Element? {
        fatalError()
    }

    mutating func update(with newMember: __owned Element) -> Element? {
        fatalError()
    }

    func subtract(_ other: Self) {
        fatalError()
    }

    func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    func isSubset(of other: Self) -> Bool {
        fatalError()
    }

    func isSuperset(of other: Self) -> Bool {
        fatalError()
    }

    func isDisjoint(with other: Self) -> Bool {
        fatalError()
    }
}

extension SparseBitArray: Sequence {
    func makeIterator() -> AnyIterator<Int> {
        fatalError()
    }
}

struct Meta: SetAlgebra, ExpressibleByArrayLiteral {

    typealias Element = Int

    typealias ArrayLiteralElement = Element

    var inner: ContiguousArray<UInt64>

    // how many blocks can this accomodate
    var blockCapacity: Int {
        self.inner.count << 6
    }

    init() {
        fatalError()
    }

    init<S>(_ sequence: __owned S) where S : Sequence, Int == S.Element {
        fatalError()
    }


    init(arrayLiteral elements: Element...) {
        fatalError()
    }

    var isEmpty: Bool {
        fatalError()
    }

    var isSome: Bool {
        fatalError()
    }

    func contains(_ member: Element) -> Bool {
        fatalError()
    }

    __consuming func union(_ other: __owned Self) -> Self {
        fatalError()
    }

    mutating func formUnion(_ other: __owned Self) {
        fatalError()
    }

    __consuming func intersection(_ other: Self) -> Self {
        fatalError()
    }

    mutating func formIntersection(_ other: Self) {
        fatalError()
    }

    __consuming func symmetricDifference(_ other: __owned Self) -> Self {
        fatalError()
    }

    mutating func formSymmetricDifference(_ other: __owned Self) {
        fatalError()
    }

    mutating func insert(
        _ newMember: __owned Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }

    mutating func remove(_ member: Element) -> Element? {
        fatalError()
    }

    mutating func update(with newMember: __owned Element) -> Element? {
        fatalError()
    }

    func subtract(_ other: Self) {
        fatalError()
    }

    func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    func isSubset(of other: Self) -> Bool {
        fatalError()
    }

    func isSuperset(of other: Self) -> Bool {
        fatalError()
    }

    func isDisjoint(with other: Self) -> Bool {
        fatalError()
    }
}
