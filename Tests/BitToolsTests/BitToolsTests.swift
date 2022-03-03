import XCTest
import BitTools
import simd

// struct A {
//    let a: SIMD64<UInt64>
//
//    init() {
//        a = SIMD64()
//    }
// }

final class BitToolsTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(BitTools().text, "Hello, World!")
    }

    func testBitRemove() {
        var a: UInt16 = 0b1010
//        XCTAssert(a.removeBit(2) == a)
//        XCTAssert(a.removeBit(1) == 8)
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

//        XCTAssert(a.bitSequence().elementsEqual([1,3,5]))

    }

    func testBoolArrayIterator() {
//        var a = Array<Bool>(repeating: false, count: 128)
//        a[10] = true
//        a[20] = true
//        a[125] = true
//        a.withUnsafeBufferPointer {
//            var i = BitPtrIterator(ptr: $0)
//            while let idx = i.next() {
//                print(idx)
//            }
//        }

        var a = [false, false, false, false, false, false, false, false,
                 true, false, false, false, false, false, false, false ]

        a.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) {
                print($0.pointee)
            }
//            var i = BitPtrIterator(ptr: $0)
//            while let idx = i.next() {
//                print(idx)
//            }
        }
    }

//    func testSimd() {
//        // 512 bytes
////        typealias T = SIMD64<UInt64>
////        let size = MemoryLayout<T>.size
////
////        let z = T()
////        let bits = z.trailingZeroBitCount
////        print(bits)
////        print(size)
//    }
}
