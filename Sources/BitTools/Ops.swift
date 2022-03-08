
extension UnsafeMutableBufferPointer where Element == UInt64 {
    // calculates a union of the two
    func union(
        _ a: UnsafeBufferPointer<UInt64>,
        _ b: UnsafeBufferPointer<UInt64>,
        minCapacity: Int,
        maxCapacity: Int

    ) -> Int {

        var nonzeroBitCount = 0

        for i in 0 ..< minCapacity {
            let new = a[i] | b[i]
            self[i] = new

            nonzeroBitCount += new.nonzeroBitCount
        }

        assert(
            a[minCapacity...].isEmpty || b[minCapacity...].isEmpty
        )

        var idx = minCapacity

        for e in a[minCapacity...] {
            self[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        for e in b[minCapacity...] {
            self[idx] = e
            nonzeroBitCount += e.nonzeroBitCount
            idx += 1
        }

        return nonzeroBitCount
    }

    /// returns diff
    @inlinable @inline(__always)
    func formUnion(
        _ other: UnsafeBufferPointer<UInt64>,
        capacity: Int
    ) -> Int {
        guard var self_ = self.baseAddress,
              var other_ = other.baseAddress else { fatalError() }

        var oldCount = 0
        var newCount = 0

        for _ in 0 ..< capacity {
            let old = self_.pointee
            let new = old | other_.pointee

            self_.pointee = new

            oldCount += old.nonzeroBitCount
            newCount += new.nonzeroBitCount

            self_ = self_.successor()
            other_ = other_.successor()
        }

        return newCount - oldCount
    }
}
