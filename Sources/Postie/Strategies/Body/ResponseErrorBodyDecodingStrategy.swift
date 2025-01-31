/// A protocol for defining strategies for handling error response bodies.
///
/// Implement this protocol to create custom strategies for handling error response bodies.
///
/// Example usage:
/// ```swift
/// public class SpecificStatusCodeDecodingStrategy: ResponseErrorBodyDecodingStrategy {
///
///     public static func isError(statusCode: Int) -> Bool {
///         return statusCode >= 400 // Handle every status code greater than 400 as an error
///     }
/// }
/// ```
public protocol ResponseErrorBodyDecodingStrategy {
    /// Using the `validate(statusCode:)` method, you can define HTTP code(s) that should handled as an error.
    ///
    /// Use this property in a custom strategy implementation (example below) to check against the response's
    /// `statusCode` and determine wether or not it should fail when receiving empty data.
    ///
    /// Indicates wether the decoding should fail when no content is returned or not.
    static func isError(statusCode: Int) -> Bool
}
