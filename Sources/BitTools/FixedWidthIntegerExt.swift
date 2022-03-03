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


extension Comparable {
    func extrema(_ other: Self) -> (lower: Self, higher: Self) {
        if self < other {
            return (self, other)
        } else {
            return (other, self)
        }
    }
}


//func subtract(Set<Element>)
//Removes the elements of the given set from this set.
//func subtract<S>(S)
//Removes the elements of the given sequence from the set.
//func subtracting(Set<Element>) -> Set<Element>
//Returns a new set containing the elements of this set that do not occur in the given set.
//func subtracting<S>(S) -> Set<Element>

extension FixedWidthInteger {
    @inline(__always)
    public func contains(bit index: Self) -> Bool {
        (self & (1 << index)) != 0
    }

    ///
    /// insert
    ///
    @inline(__always)
    public mutating func insert(bit index: Self) {
        self = self.inserting(bit: index)
    }

    @inline(__always)
    public func inserting(bit index: Self) -> Self {
        self | (1 << index)
    }

    ///
    /// remove
    ///
    @inline(__always)
    public mutating func remove(bit index: Self) {
        self = self.removing(bit: index)
    }

    @inline(__always)
    public func removing(bit index: Self) -> Self {
        self & ~(1 << index)
    }

    ///
    /// subtracting (andnot)
    ///
    @inline(__always)
    public func subtracting(bits other: Self) -> Self {
        self & ~other
    }

    @inline(__always)
    public mutating func subtract(bits other: Self) {
        self = self.subtracting(bits: other)
    }


    mutating func removeAll(
        where shouldBeRemoved: (Self) throws -> Bool
    ) rethrows {
        var i = BitIterator(self)

        while let next = i.next() {
            let nxt = Self(exactly: next)!
            if try shouldBeRemoved(nxt) {
                self.remove(bit: nxt)
            }
        }
    }

    func removingAll(
        where shouldBeRemoved: (Self) throws -> Bool
    ) rethrows -> Self {
        var s = self
        try s.removeAll(where: shouldBeRemoved)
        return s
    }
}

extension FixedWidthInteger {
    func roundUp(to: Self) -> Self {
        let m = self % to
        if m == 0 {
            return self
        } else {
            return self - m + to
        }
    }

    var pageAligned: Self {
        self.roundUp(to: 4096)
    }

    ///
    /// how many blocks are needed to accomodate this number
    /// 0 => 1
    /// 127 => 2
    /// 128 => 3
    func blockCount(bitWidth: Int) -> Int {
        let count = (self + 1).roundUp(to: Self(bitWidth))
        return Int(count / Self(bitWidth))
    }
}


extension BinaryInteger {
    public func truncate(to bits: Int) -> Self {
//        print("truncate \(Self.self) to \(bitWidth)")
        self & Self(1 << bits - 1)
    }
}
//
//public extension FixedWidthInteger {
//    // from https://stackoverflow.com/questions/67745231/how-do-i-perform-a-circular-shift-in-swift
////    let shift = n % $bits;
////               let mask = self.mask().0;
////               $name((mask << shift) | (mask >> ($bits - shift)))
//    @inline(__always)
//    func rotateLeft(by shiftAmount: Int) -> Self {
//        let shift = shiftAmount % Self.bitWidth
//        if shift < 0 {
//            return rotateRight(by: -shift)
//        }
//        return (self << shift) | (self >> (Self.bitWidth - shift))
//    }
//
//    @inline(__always)
//    func rotateRight(by shiftAmount: Int) -> Self {
//        let shift = shiftAmount % Self.bitWidth
//        if shift < 0 {
//            return rotateLeft(by: -shift)
//        }
//        return (self >> shift) | (self << (Self.bitWidth - shift))
//    }
//}
//
////extension UnsignedInteger {
////
////}
//
//// unsigned int nth_bit_set(uint32_t value, unsigned int n)
//// {
////    uint32_t      mask = 0x0000FFFFu;
////    unsigned int  size = 16u;
////    unsigned int  base = 0u;
////
////    if (n++ >= __builtin_popcount(value))
////        return 32;
////
////    while (size > 0) {
////        const unsigned int  count = __builtin_popcount(value & mask);
////        if (n > count) {
////            base += size;
////            size >>= 1;
////            mask |= mask << size;
////        } else {
////            size >>= 1;
////            mask >>= size;
////        }
////    }
////
////    return base;
//// }
//// finds the nth bit set
////func nthbitset(_ value: UInt32, n: UInt) -> UInt {
////    var mask: UInt32 = 0x0000ffff
////    var size: UInt16 = 16
////    var base: UInt = 0
////    let n = n + 1
////
////    if n > value.nonzeroBitCount {
////        return 32
////    }
////
////    while size > 0 {
////        let count = value & mask
////        if n > count {
////            base += UInt(size)
////            size >>= 1
////            mask |= mask << size
////        } else {
////            size >>= 1
////            mask >>= size
////        }
////    }
////    return base
////}
//
//public extension FixedWidthInteger {
//    @inline(__always)
//    func containsBit(_ at: Self) -> Bool {
//        self & (1 << at) != 0
//    }
//
//
//    @inline(__always)
//    mutating func insertBit(_ newMember: Self) {
////        defer {
//        self |= (1 << newMember)
////        }
////        return self.containsBit(newMember)
//
//    }
//
//    @inline(__always)
//    mutating func removeBit(_ newMember: Self) {
////        defer {
//        self &= ~(1 << newMember)
////        }
////        if self.containsBit(newMember) {
////            return newMember
////        } else {
////            return nil
////        }
//    }
//
//    @inline(__always)
//    func unionBits(_ other: Self) -> Self {
//        self | other
//    }
//
//    @inline(__always)
//    func intersectBits(_ other: Self) -> Self {
//        self & other
//    }
//
//    func symmetricDifference(_ other: Self) -> Self {
//        self ^ other
//    }
//}
//
//extension FixedWidthInteger {
//    public func bitSequence() -> BitSequence<Self> {
//        BitSequence(value: self)
//    }
//}


//extension RawGPUArray where Element == Bool {
//    func iterSetBits() -> AnyIterator<Int> {
//        let blockSize = MemoryLayout<UInt64>.size
//        let byteSize = self.memAlign.byteSize
//        let capacity = byteSize / blockSize
//        assert(byteSize % blockSize == 0)
//        let ptr = self.ptr.baseAddress!.withMemoryRebound(to: UInt64.self, capacity: capacity) { ptr in
//            ptr
//        }
//
//        var i = 0
//        var currentBlock: UInt64 = 0
//        var leading = 0
//
//        return AnyIterator {
//            guard i < capacity else { return nil }
//            while currentBlock == 0 {
//                currentBlock = ptr.advanced(by: i).pointee
//                i += 1
//                leading += blockSize
//                guard i < capacity else { return nil }
//            }
//
//            return leading + currentBlock.leadingZeroBitCount
//
//        }
//    }
//}
