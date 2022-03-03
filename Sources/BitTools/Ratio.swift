protocol DivMod {
    func divMod(_ other: Self) -> (Self, Self)
}

public struct Ratio: Equatable {
    let quot: Int
    let rem: Int
}

extension Int {
    public func ratio(_ other: Int) -> Ratio {
        let (quot, rem) = self.divMod(other)
        return Ratio(quot: quot, rem: rem)
    }
}

extension Int: DivMod {
    func divMod(_ other: Self) -> (Self, Self) {
        self.quotientAndRemainder(dividingBy: other)
    }
}
