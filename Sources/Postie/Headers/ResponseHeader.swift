@propertyWrapper
public struct ResponseHeader<DecodingStrategy: ResponseHeaderDecodingStrategy> {

    public var wrappedValue: DecodingStrategy.RawValue

    public init(wrappedValue: DecodingStrategy.RawValue) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseHeader: Decodable where DecodingStrategy.RawValue: Decodable {

    public init(from decoder: Decoder) throws {
        wrappedValue = try DecodingStrategy.decode(decoder: decoder)
    }
}

public protocol ResponseHeaderDecodingStrategy {
    associatedtype RawValue: Codable

    static func decode(decoder: Decoder) throws -> RawValue
}

enum ResponseHeaderDecodingError: Error {
    case missingCodingKey
}
