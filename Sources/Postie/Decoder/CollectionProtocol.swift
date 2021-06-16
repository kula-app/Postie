/// Protocol used to determine the element type of a generic collection
protocol CollectionProtocol {

    /// Static function to get the element type of the given collection type, e.g. `Element` for `Array<Element>`
    ///
    /// - Returns: Type of element
    static func getElementType() -> Any.Type
}

extension Array: CollectionProtocol {

    /// Static function to get the element type of the given array type, e.g. `Element` for `Array<Element>`
    ///
    /// - Returns: Type of element
    static func getElementType() -> Any.Type {
        return Element.self
    }
}

extension Set: CollectionProtocol {

    /// Static function to get the element type of the given set type, e.g. `Element` for `Set<Element>`
    ///
    /// - Returns: Type of element
    static func getElementType() -> Any.Type {
        return Element.self
    }
}
