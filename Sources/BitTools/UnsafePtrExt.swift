

extension UnsafeMutableBufferPointer where Element == UInt64 {
    public func formUnion(_ other: UnsafeBufferPointer<Element>, count: Int) -> Int {
        guard var a = self.baseAddress,
              var b = other.baseAddress else { fatalError() }

        var bitCount = 0
        for _ in 0..<count {
            let new = a.pointee | b.pointee
            a = a.successor()
            b = b.successor()
            a.pointee = new
            bitCount += new.nonzeroBitCount
        }
        return bitCount
    }

    public func formIntersection(_ other: UnsafeBufferPointer<Element>, count: Int) -> Int {
        guard var a = self.baseAddress,
              var b = other.baseAddress else { fatalError() }

        var bitCount = 0
        for _ in 0..<count {
            let new = a.pointee & b.pointee
            a = a.successor()
            b = b.successor()
            a.pointee = new
            bitCount += new.nonzeroBitCount
        }
        return bitCount
    }

//    func copy(_ other: )
}
