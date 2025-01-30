/// A basic `CodingKey` implementation.
public struct BasicKey: CodingKey {
    /// See `CodingKey`.
    public var stringValue: String

    /// See `CodingKey`.
    public var intValue: Int?

    /// Creates a new `BasicKey` from a `String.`
    public init(_ string: String) {
        self.stringValue = string
    }

    /// Creates a new `BasicKey` from a `Int.`
    ///
    /// These are usually used to specify array indexes.
    public init(_ int: Int) {
        self.intValue = int
        self.stringValue = int.description
    }

    /// See `CodingKey`.
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    /// See `CodingKey`.
    public init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = intValue.description
    }
}
