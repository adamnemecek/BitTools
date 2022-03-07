import XCTest
import BitTools




class BitArrayTest: XCTestCase {
    typealias Harness = BitArrayTestHarness<BitArray>

    func testBundle() {
        //        koremetalbundle()
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

    func testFormIntersection1() {
        var a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        print(a)

        let b: BitArray = [10,  22, 75, 63, 100]

//        print(b)

        a.formIntersection(b)


        print(a)
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

    func testFormSymmetricDifference() {
        var a: BitArray = [60, 80, 63, 70, 75, 300, 1000]
        print(a)

        let b: BitArray = [10,  22, 75, 63, 100]

//        print(b)

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
