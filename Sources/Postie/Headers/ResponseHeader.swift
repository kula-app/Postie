@propertyWrapper
public struct ResponseHeader<DecodingStrategy: ResponseHeaderDecodingStrategy> {

    public var wrappedValue: DecodingStrategy.RawValue

    public init(wrappedValue: DecodingStrategy.RawValue) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseHeader: Decodable where DecodingStrategy.RawValue: Decodable {

    public init(from decoder: Decoder) throws {
        self.wrappedValue = try DecodingStrategy.decode(decoder: decoder)
    }
}

public protocol ResponseHeaderDecodingStrategy {
    associatedtype RawValue: Codable

    static func decode(decoder: Decoder) throws -> RawValue
}

public struct DefaultStrategy: ResponseHeaderDecodingStrategy {

    public typealias RawValue = String

    public static func decode(decoder: Decoder) throws -> RawValue {
        guard let key = decoder.codingPath.last?.stringValue else {
            throw ResponeHeaderDecodingError.missingCodingKey
        }
        // Check if the decoder is response decoder, otherwise fall back to default decoding logic
        guard let responseDecoding = decoder as? ResponseDecoding else {
            return try RawValue(from: decoder)
        }
        // Transform dash separator to camelCase
        guard let value = responseDecoding.valueForHeaderCaseInsensitive(key) else {
            throw DecodingError.valueNotFound(RawValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Missing value for case-insensitive header key: \(key)"))
        }
        return value
    }
}

public struct DefaultStrategyOptional: ResponseHeaderDecodingStrategy {

    public typealias RawValue = String?

    public static func decode(decoder: Decoder) throws -> RawValue {
        guard let key = decoder.codingPath.last?.stringValue else {
            throw ResponeHeaderDecodingError.missingCodingKey
        }
        // Check if the decoder is response decoder, otherwise fall back to default decoding logic
        guard let responseDecoding = decoder as? ResponseDecoding else {
            return try RawValue(from: decoder)
        }
        // Transform dash separator to camelCase
        return responseDecoding.valueForHeaderCaseInsensitive(key)
    }
}

enum ResponeHeaderDecodingError: Error {
    case missingCodingKey
}
