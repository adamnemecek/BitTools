import Foundation

extension BinaryInteger {
    public var binaryDescription: String {
        var binaryString = ""
        var n = self
        var counter = 0

        for _ in 1...self.bitWidth {
            binaryString.insert(contentsOf: "\(n & 1)", at: binaryString.startIndex)
            n >>= 1
            counter += 1
            if counter % 4 == 0 {
                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
            }
        }

        return binaryString
    }
}

extension BinaryInteger {
    public func truncate(to bits: Int) -> Self {
//        print("truncate \(Self.self) to \(bitWidth)")
        self & Self(1 << bits - 1)
    }
}

public extension FixedWidthInteger {
    // from https://stackoverflow.com/questions/67745231/how-do-i-perform-a-circular-shift-in-swift
//    let shift = n % $bits;
//               let mask = self.mask().0;
//               $name((mask << shift) | (mask >> ($bits - shift)))
    @inline(__always)
    func rotateLeft(by shiftAmount: Int) -> Self {
        let shift = shiftAmount % Self.bitWidth
        if shift < 0 {
            return rotateRight(by: -shift)
        }
        return (self << shift) | (self >> (Self.bitWidth - shift))
    }

    @inline(__always)
    func rotateRight(by shiftAmount: Int) -> Self {
        let shift = shiftAmount % Self.bitWidth
        if shift < 0 {
            return rotateLeft(by: -shift)
        }
        return (self >> shift) | (self << (Self.bitWidth - shift))
    }
}

//extension UnsignedInteger {
//
//}

// unsigned int nth_bit_set(uint32_t value, unsigned int n)
// {
//    uint32_t      mask = 0x0000FFFFu;
//    unsigned int  size = 16u;
//    unsigned int  base = 0u;
//
//    if (n++ >= __builtin_popcount(value))
//        return 32;
//
//    while (size > 0) {
//        const unsigned int  count = __builtin_popcount(value & mask);
//        if (n > count) {
//            base += size;
//            size >>= 1;
//            mask |= mask << size;
//        } else {
//            size >>= 1;
//            mask >>= size;
//        }
//    }
//
//    return base;
// }
// finds the nth bit set
//func nthbitset(_ value: UInt32, n: UInt) -> UInt {
//    var mask: UInt32 = 0x0000ffff
//    var size: UInt16 = 16
//    var base: UInt = 0
//    let n = n + 1
//
//    if n > value.nonzeroBitCount {
//        return 32
//    }
//
//    while size > 0 {
//        let count = value & mask
//        if n > count {
//            base += UInt(size)
//            size >>= 1
//            mask |= mask << size
//        } else {
//            size >>= 1
//            mask >>= size
//        }
//    }
//    return base
//}

public extension FixedWidthInteger {
    @inline(__always)
    func containsBit(_ at: Self) -> Bool {
        self & (1 << at) != 0
    }

    @inline(__always)
    mutating func insertBit(_ newMember: Self) -> (inserted: Bool, memberAfterInsert: Self) {
        defer {
            self |= (1 << newMember)
        }
        return (!self.containsBit(newMember), newMember)

    }

    @inline(__always)
    mutating func removeBit(_ newMember: Self) -> Self? {
        defer {
            self &= ~(1 << newMember)
        }
        if self.containsBit(newMember) {
            return newMember
        } else {
            return nil
        }
    }

    @inline(__always)
    func unionBits(_ other: Self) -> Self {
        self | other
    }

    @inline(__always)
    func intersectBits(_ other: Self) -> Self {
        self & other
    }
}

extension FixedWidthInteger {
    public func bitSequence() -> BitSequence<Self> {
        BitSequence(value: self)
    }
}
