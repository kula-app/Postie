public protocol ResponseHeaderDecodingStrategy {
    associatedtype RawValue: Codable

    static func decode(decoder: Decoder) throws -> RawValue
}

enum ResponseHeaderDecodingError: Error {
    case missingCodingKey
}
