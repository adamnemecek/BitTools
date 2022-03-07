
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
}
