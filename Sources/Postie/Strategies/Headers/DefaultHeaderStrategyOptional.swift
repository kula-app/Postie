import Foundation

public struct DefaultHeaderStrategyOptional: ResponseHeaderDecodingStrategy {

    public typealias RawValue = String?

    public static func decode(decoder: Decoder) throws -> RawValue {
        guard let key = decoder.codingPath.last?.stringValue else {
            throw ResponseHeaderDecodingError.missingCodingKey
        }
        // Check if the decoder is response decoder, otherwise fall back to default decoding logic
        guard let responseDecoding = decoder as? ResponseDecoding else {
            return try RawValue(from: decoder)
        }
        // Transform dash separator to camelCase
        return responseDecoding.valueForHeaderCaseInsensitive(key)
    }
}
