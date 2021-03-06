import XCTest
import BitTools

func slowBitVector<T: FixedWidthInteger>(_ value: T) -> [T] {
    (0..<T(value.bitWidth)).filter { value.contains(bit: $0) }
}

// func slowBitReduce(_ a: [Int]) -> Int {
//    a.reduce(0) { $0.insert(bit: <#T##Int#>)}
// }

class BitSequenceTests: XCTestCase {

    func testSlowBitVector() {
        let a = 0b10010010010

//        let expected = [1, 4, 7, 10]
//        let result = slowBitVector(a)
////        let s = BitSequence(a)
//        let s = BitSequence(a)
//        XCTAssert(expected.elementsEqual(result))
//        XCTAssert(expected.elementsEqual(s))
    }

    func testBitCapacity() {
        let a = [Int](bitCapacity: 16)
        print(a.count)
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
