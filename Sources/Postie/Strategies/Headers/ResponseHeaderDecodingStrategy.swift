public protocol ResponseHeaderDecodingStrategy {
    /// The type of the raw value that will be decoded from the response header.
    ///
    /// This associated type represents the type of the raw value that will be decoded from the response header.
    /// It must conform to the `Codable` protocol.
    associatedtype RawValue: Codable

    /// Decodes the raw value from the given decoder.
    ///
    /// This method is responsible for decoding the raw value from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Returns: The decoded raw value.
    /// - Throws: An error if the decoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let decoder = JSONDecoder()
    /// let rawValue = try MyHeaderDecodingStrategy.decode(decoder: decoder)
    /// ```
    static func decode(decoder: Decoder) throws -> RawValue
}

/// Represents errors that can occur during response header decoding.
///
/// The `ResponseHeaderDecodingError` enum provides a list of errors that can occur during response header decoding.
enum ResponseHeaderDecodingError: Error {
    /// Indicates that the coding key is missing.
    ///
    /// This error occurs when the coding key is missing during the decoding process.
    case missingCodingKey
}
