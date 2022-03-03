import XCTest
import BitTools

class BitArrayTest: XCTestCase {

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

    func testUnion() {
        let aa = [1,1000,20, 200]
        let a = BitArray(aa)

        let bb = [2,2000,40, 400]
        let b = BitArray(bb)

        let c = BitArray(aa + bb)

        let result = a.union(b)
        let expected = (aa + bb).sorted()

        XCTAssert(result.elementsEqual(expected))
        XCTAssert(c == result)

        XCTAssert(result.count == 8)
    }

    func testFormUnion() {

        var a: BitArray = [1,2,1000, 2000]
        a.formUnion([1, 200, 3000, 40, 5000])

//        let expected = (a)
        print(a.count )
        print(a)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
