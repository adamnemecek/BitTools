import XCTest
import BitTools

final class BitToolsTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(BitTools().text, "Hello, World!")
    }

    func testBitRemove() {
        var a: UInt16 = 0b1010
        XCTAssert(a.removeBit(2) == a)
        XCTAssert(a.removeBit(1) == 8)
    }

    func testTruncate() {
//        let a: UInt16 = 0b101010
//        XCTAssert(a.truncate(to: 4) == 0b1010)
        let b: UInt16 = 2
        print(b.truncate(to: 11))
    }

    func testBitIterator() {
        let a: UInt16 = 0b101010

//        for e in a.bitSequence() {
//            print(e)
//        }

        XCTAssert(a.bitSequence().elementsEqual([1,3,5]))

    }
}
