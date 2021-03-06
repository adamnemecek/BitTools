import XCTest
import BitTools

// func check(_ a: BitArray, _ b: Set<Int>) -> Bool {
//    guard a.count == b.count else { return false }
//    let sorted = b.sorted()
//    return a.elementsEqual(sorted)
// }
extension Range where Bound == Int {
    func randomElements(_ count: Int) -> [Bound] {
        (0..<count).map { _ in self.randomElement()! }
    }
}

extension BitArray {
    func equal(to other: Set<Int>) -> Bool {
        let sorted = other.sorted()
        return self.count == sorted.count && self.elementsEqual(sorted)
    }
}

// func testUnion(_ a: [Int], _ b: [Int]) -> Bool {
//    let a = BitArray(a)
//    let b = BitArray(b)
//
//    let expected = Set(a).union(b)
//    let result = a.union(b)
//
//    return result.equal(to: expected)
// }
//
// func testFormUnion(_ a: [Int], _ b: [Int]) -> Bool {
//    let a = BitArray(a)
//    let b = BitArray(b)
//
//    let expected = Set(a).union(b)
//    let result = a.union(b)
//
//    return result.equal(to: expected)
// }

extension BitArray {
    // - `S() == []`
    static func testRule1() -> Bool {
        Self() == []
    }

    // - `x.intersection(x) == x`
    func testRule2() -> Bool {
        self.intersection([]) == []
    }

    // - `x.intersection([]) == []`
    static func testRule3() -> Bool {
        Self([]).intersection([]) == []
    }

    // - `x.union(x) == x`
    func testRule4() -> Bool {
        self.union(self) == self
    }
    // - `x.union([]) == x`
    func testRule5() -> Bool {
        self.union([]) == self
    }
    // - `x.contains(e)` implies `x.union(y).contains(e)`
//    func testRule5() -> Bool {
//        let e = self.randomElement()
//        return true
//    }
    // - `x.union(y).contains(e)` implies `x.contains(e) || y.contains(e)`
    // - `x.contains(e) && y.contains(e)` if and only if
    //   `x.intersection(y).contains(e)`
    // - `x.isSubset(of: y)` if and only if `y.isSuperset(of: x)`
    // - `x.isStrictSuperset(of: y)` if and only if `x.isSuperset(of: y) && x != y`
    // - `x.isStrictSubset(of: y)` if and only if `x.isSubset(of: y) && x != y`
    func testRules() {


    }
}

class BitArrayTest: XCTestCase {
//    typealias Harness = BitArrayTestHarness<BitArray>

    func testBundle() {
        //        koremetalbundle()
    }

    func testArrayExpressible() {
        let a: BitArray = [0,10,20,30,100]

        XCTAssert(a.elementsEqual([0,10,20,30,100]))
    }

    func testRules() {
        let a: BitArray = [1,2,3,10, 20]
//        XCTAssert(BitArray() == [])
//
//        XCTAssert(a.intersection(a) == a)
        // - `S() == []`
        // - `x.intersection(x) == x`
        // - `x.intersection([]) == []`
        // - `x.union(x) == x`
        // - `x.union([]) == x`
        // - `x.contains(e)` implies `x.union(y).contains(e)`
        // - `x.union(y).contains(e)` implies `x.contains(e) || y.contains(e)`
        // - `x.contains(e) && y.contains(e)` if and only if
        //   `x.intersection(y).contains(e)`
        // - `x.isSubset(of: y)` if and only if `y.isSuperset(of: x)`
        // - `x.isStrictSuperset(of: y)` if and only if
        //   `x.isSuperset(of: y) && x != y`
        // - `x.isStrictSubset(of: y)` if and only if `x.isSubset(of: y) && x != y`

    }

    func testUnion1() {
        let a: BitArray = [60, 80, 70, 75]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(a).union(b)
        let result = a.union(b)

        XCTAssert(result.equal(to: expected))
    }

    func testFormUnion1() {
        var result: BitArray = [60, 80, 70, 75]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(result).union(b)
        result.formUnion(b)

        XCTAssert(result.equal(to: expected))
    }

    func testIntersection1() {
        let a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(a).intersection(b)
        let result = a.intersection(b)

        XCTAssert(result.equal(to: expected))
    }

//    func testIntersectionRandom() {
//        let a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
//        let b: BitArray = [10, 22, 75, 63, 100]
//
//        let expected = Set(a).intersection(b)
//        let result = a.intersection(b)
//
//        XCTAssert(result.equal(to: expected))
//    }

    func testFormIntersection1() {
        var result: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(result).intersection(b)
        result.formIntersection(b)

        XCTAssert(result.equal(to: expected))
    }

    func testModule() {
        var a: BitArray = [60, 80, 70, 75]
        print(a)

        let b: BitArray = [10, 22, 75, 63, 100]

        print(b)

        a.formUnion(b)

        print(a)
        print(a.count)
//        XCTAssert(a.check())
//        var a: Harness = [60, 80, 70]
//
//        let b: Harness = [10, 63, 22]
//
//        a.formUnion(b)
//
//        XCTAssert(a.check())
    }

//    func testFormIntersection1() {
//        var a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
//        print(a)
//
//        let b: BitArray = [10,  22, 75, 63, 100]
//
////        print(b)
//
//        a.formIntersection(b)
//
//
//        print(a)
////        XCTAssert(a.check())
////        print(a.count == a.nonzeroBitCount())
////        XCTAssert(a.check())
////        var a: Harness = [60, 80, 70]
////
////        let b: Harness = [10, 63, 22]
////
////        a.formUnion(b)
////
////        XCTAssert(a.check())
//    }

    func testSymmetricDifference1() {
        let a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(a).symmetricDifference(b)
        let result = a.symmetricDifference(b)

        XCTAssert(result.equal(to: expected))
    }

    func testFormSymmetricDifference1() {
        var result: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(result).symmetricDifference(b)
        result.formSymmetricDifference(b)

        XCTAssert(result.equal(to: expected))
    }

    func testSubtracting() {
        let a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(a).subtracting(b)
        let result = a.subtracting(b)
        print(expected)
        print(result)

        XCTAssert(result.equal(to: expected))
    }

    func testSubtract() {
        var result: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        let b: BitArray = [10, 22, 75, 63, 100]

        let expected = Set(result).subtracting(b)
        result.subtract(b)

        XCTAssert(result.equal(to: expected))
    }

    func testSubtract1() {
        var result: BitArray =  [10, 22, 75, 63, 100]
        let b: BitArray = [60, 80, 63, 70, 75, 300, 1000]

        let expected = Set(result).subtracting(b)
        result.subtract(b)

        XCTAssert(result.equal(to: expected))
    }

    func testFormSymmetricDifference() {
        var a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        print(a)

        let b: BitArray = [10, 22, 75, 63, 100]

        a.formSymmetricDifference(b)

//        XCTAssert(a.check())
//        print(a.count == a.nonzeroBitCount())
//        XCTAssert(a.check())
//        var a: Harness = [60, 80, 70]
//
//        let b: Harness = [10, 63, 22]
//
//        a.formUnion(b)
//
//        XCTAssert(a.check())
    }

    func testIsSubset() {
        let sub: BitArray = [10, 20, 30, 40, 50]
        let sup: BitArray = [10, 20, 30, 40, 50, 60]

        let expected = Set(sub).isSubset(of: sup)
        let result = sub.isSubset(of: sup)
        XCTAssert(expected == result)

        let expected1 = Set(sup).isSubset(of: sub)
        let result1 = sup.isSubset(of: sub)
        XCTAssert(expected1 == result1)

        let expected2 = Set(sub).isSubset(of: sub)
        let result2 = sub.isSubset(of: sub)
        print(expected2, expected2 == result2)
    }

    func testEq() {
        var a: BitArray = [1,2,3,4, 1000]
        var b: BitArray = [1,2,3,4]

        XCTAssert(a != b)
        XCTAssert(a.count == 5)

        a.remove(1000)

        XCTAssert(a == b)
        XCTAssert(a.count == 4)

        b.insert(2000)

        XCTAssert(a != b)
        XCTAssert(b.count == 5)

        b.remove(2000)

        XCTAssert(a == b)
        XCTAssert(b.count == 4)
    }

    func testIsDisjoint() {
        let a: BitArray = [1,2,3,4, 1000]
        let b: BitArray = [1,2,3,4]

        XCTAssert(!a.isDisjoint(with: b))

        let c: BitArray = [3,4,5,6]
        let d: BitArray = [7,8,9,10,11]
        XCTAssert(c.isDisjoint(with: d))
    }

    func testRemove() {
        var a: BitArray = [0, 10, 20, 500, 1000]
        XCTAssert(a.contains(0))

        XCTAssert(a.count == 5)
        XCTAssert(a.contains(20))
        XCTAssert(!a.contains(30))

        _ = a.remove(20)
        XCTAssert(a.count == 4)
        XCTAssert(!a.contains(20))

        _ = a.remove(500)
        XCTAssert(a.count == 3)
        XCTAssert(!a.contains(500))
//        XCTAssert(!a.contains(30))

    }

    func testSubscript() {
        var a: BitArray = [0, 10, 20, 500, 1000]

        XCTAssert(a.count == 5)
        XCTAssert(a[20])
        XCTAssert(!a[30])

        a[30] = true
        XCTAssert(a[30])
        XCTAssert(a.count == 6)

        a[30] = false
        XCTAssert(!a[30])
        XCTAssert(a.count == 5)

        a[5000] = true

        XCTAssert(a[5000])
        XCTAssert(a.count == 6)
    }

    func testBitArray() {
        var a: BitArray = [100, 64, 1000]

        XCTAssert(a.contains(100))
        XCTAssert(a.contains(64))
        XCTAssert(a.contains(1000))

        XCTAssert(!a.contains(5000))
        XCTAssert(a.count == 3)
//        for e in a {
//            print(e)
//        }
    }

    func testEqual() {
        var a: BitArray = [1, 2, 4, 10, 1000, 10000]
        _ = a.remove(20000)
        _ = a.remove(10000)
        _ = a.insert(20000)
        _ = a.remove(20000)

        var b: BitArray = [4, 10, 2]
        _ = b.insert(1000)
        _ = b.insert(1)

        XCTAssert(b.count == 5)
        XCTAssert(a == b)

    }

    func testAndNot() {
        let a = 0b101010
        let b = 0b110000
        let c = 0b001010

        print((a & ~b) == c)
    }

    func testRemoveAll() {
        let expected = [1, 3, 5, 7, 9]
        var result = BitArray((0..<10))
        result.removeAll { $0 % 2 == 0 }
        XCTAssert(result.count == 5)
        XCTAssert(expected.elementsEqual(result))
    }

    func testUnion() {
        let aa = [1, 1000, 20, 200]
        let a = BitArray(aa)

        let bb = [2, 2000, 40, 400]
        let b = BitArray(bb)

        let c = BitArray(aa + bb)

        let result = a.union(b)
        let expected = (aa + bb).sorted()
        print(expected)
        print(result)

        XCTAssert(result.elementsEqual(expected))
        XCTAssert(c == result)

        XCTAssert(result.count == 8)
    }

    func testIter() {
        let a: BitArray = [1, 2, 3, 4, 10, 12]

        for e in a {
            print(e)
        }
    }

    func testFormUnion() {

        var a: BitArray = [1, 2, 10, 20]
        print(a.capacity)
        let b: BitArray = [1, 4, 6]
        print(b.capacity)
        a.formUnion(b)

//        let expected = (a)
        print(a.count )
        print(a)
    }

    func testIntersection() {
        let a: BitArray = [1, 2, 3, 4, 5, 6]
        let b: BitArray = [2, 3, 4, 5, 6]

        let expected: BitArray = [2, 3, 4, 5, 6]
        let result = a.intersection(b)
        print(expected)
        print(result)
        XCTAssert(result == expected)
    }

    func testFormIntersection() {
        var result: BitArray = [1, 2, 3, 4, 5, 6]
        let b: BitArray = [2, 3, 4, 5, 6]

        result.formIntersection(b)

        let expected: BitArray = [2, 3, 4, 5, 6]
        XCTAssert(result == expected)
    }
}
