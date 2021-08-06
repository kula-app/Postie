public protocol ResponseBodyDecodingStrategy {

    /// Indicates wether the decoding should fail on empty body or not.
    static var allowsEmptyContent: Bool { get }

    ///
    /// Use this property in a custom strategy implementation (example below) to check against the response's `statusCode` and determine wether or not it should fail when receiving empty data.
    ///
    /// ```swift
    /// public class SpecificStatusCodeDecodingStrategy: ResponseBodyDecodingStrategy {
    ///
    ///     public static var statusCode: Int?
    ///
    ///     public static var allowsEmptyContent: Bool {
    ///         guard let statusCode = statusCode else {
    ///             return false
    ///         }
    ///         return statusCode == // some statusCode value
    ///     }
    /// }
    ///
    static var statusCode: Int? { get set }
}
