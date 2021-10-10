// Credits to: https://stackoverflow.com/a/24051661/1700795
extension Array where Element: Equatable {


    /// Remove first collection element that is equal to the given `object`
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}
