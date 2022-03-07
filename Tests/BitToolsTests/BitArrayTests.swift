import XCTest
import BitTools

//func check(_ a: BitArray, _ b: Set<Int>) -> Bool {
//    guard a.count == b.count else { return false }
//    let sorted = b.sorted()
//    return a.elementsEqual(sorted)
//}
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

//func testUnion(_ a: [Int], _ b: [Int]) -> Bool {
//    let a = BitArray(a)
//    let b = BitArray(b)
//
//    let expected = Set(a).union(b)
//    let result = a.union(b)
//
//    return result.equal(to: expected)
//}
//
//func testFormUnion(_ a: [Int], _ b: [Int]) -> Bool {
//    let a = BitArray(a)
//    let b = BitArray(b)
//
//    let expected = Set(a).union(b)
//    let result = a.union(b)
//
//    return result.equal(to: expected)
//}


class BitArrayTest: XCTestCase {
    typealias Harness = BitArrayTestHarness<BitArray>

    func testBundle() {
        //        koremetalbundle()
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
        let b: BitArray = [10,  22, 75, 63, 100]

        let expected = Set(result).intersection(b)
        result.formIntersection(b)

        XCTAssert(result.equal(to: expected))
    }

    func testModule() {
        var a: BitArray = [60, 80, 70, 75]
        print(a)

        let b: BitArray = [10,  22, 75, 63, 100]

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
        let b: BitArray = [10,  22, 75, 63, 100]

        let expected = Set(result).symmetricDifference(b)
        result.formSymmetricDifference(b)

        XCTAssert(result.equal(to: expected))
    }

    func testFormSymmetricDifference() {
        var a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        print(a)

        let b: BitArray = [10,  22, 75, 63, 100]



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

    func testBitArray() {
        var a: BitArray = [100, 64, 1000]

        XCTAssert(a.contains(100))
        XCTAssert(a.contains(64))
        XCTAssert(a.contains(1000))

        XCTAssert(!a.contains(5000))
        XCTAssert(a.count == 3)
        for e in a {
            print(e)
        }
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
        let a: BitArray = [1,2,3,4,10,12]

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
