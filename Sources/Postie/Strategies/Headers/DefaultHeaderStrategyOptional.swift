import Foundation

/// A default strategy for decoding optional response headers.
///
/// The `DefaultHeaderStrategyOptional` struct provides a default strategy for decoding optional response headers
/// by checking if the header key is present in the response decoder.
///
/// Example usage:
/// ```
/// @ResponseHeaderWrapper<Header, DefaultHeaderStrategyOptional> var header: Header?
/// ```
public struct DefaultHeaderStrategyOptional<RawValue>: ResponseHeaderDecodingStrategy where RawValue: Codable {
    /// Decodes the response header value from the given decoder.
    ///
    /// - Parameter decoder: The decoder to decode the header value from.
    /// - Returns: The decoded header value, or `nil` if the header key is missing or the decoder is not a response decoder.
    /// - Throws: An error if the header key is missing or the decoder is not a response decoder.
    public static func decode(decoder: Decoder) throws -> RawValue? {
        guard let key = decoder.codingPath.last?.stringValue else {
            throw ResponseHeaderDecodingError.missingCodingKey
        }
        // Check if the decoder is response decoder, otherwise fall back to default decoding logic
        guard let responseDecoding = decoder as? ResponseDecoding else {
            return try RawValue(from: decoder)
        }
        // Transform dash separator to camelCase
        guard let value: RawValue? = responseDecoding.valueForHeaderCaseInsensitive(key) else {
            return nil
        }
        return value
    }
}
