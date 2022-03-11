import XCTest
@testable import BitTools

class SparseBitArrayTests: XCTestCase {
    func testMeta() {
        let a: ContiguousArray<UInt64> = [1, 1, 0, 1]
        a.withUnsafeBufferPointer {
            let z = Meta(ptr: $0)

            print(z.inner.debugDescription)
//            for e in z {
//                print(e)
//            }
        }


    }
    func testInsert() {

    }

    func testContains() {
        
    }

}
