import Foundation

public struct DefaultHeaderStrategy<RawValue>: ResponseHeaderDecodingStrategy where RawValue: Codable {
    public static func decode(decoder: Decoder) throws -> RawValue {
        guard let key = decoder.codingPath.last?.stringValue else {
            throw ResponseHeaderDecodingError.missingCodingKey
        }
        // Check if the decoder is response decoder, otherwise fall back to default decoding logic
        guard let responseDecoding = decoder as? ResponseDecoding else {
            return try RawValue(from: decoder)
        }
        // Transform dash separator to camelCase
        guard let value: RawValue = responseDecoding.valueForHeaderCaseInsensitive(key) else {
            throw DecodingError.valueNotFound(RawValue.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Missing value for case-insensitive header key: \(key)"
            ))
        }
        return value
    }
}
