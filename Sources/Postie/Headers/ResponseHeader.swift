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

public protocol ResponseBodyDecodingStrategy {

    ///
    /// Use this property in a custom strategy implementation (example below) to check against the response's `statusCode` and determine wether or not it should fail when receiving empty data.
    ///
    /// ```swift
    /// public class SpecificStatusCodeDecodingStrategy:ResponseBodyDecodingStrategy {
    ///
    ///     public static var statusCode: Int?
    ///
    ///     public static var allowsEmptyBody: Bool {
    ///         guard let statusCode = statusCode else {
    ///             return false
    ///         }
    ///         return statusCode == // some statusCode value
    ///     }
    /// }
    ///
    static var statusCode: Int? { get set }

    /// Indicates wether the decoding should fail on empty body or not.
    static var allowsEmptyBody: Bool { get }
}
