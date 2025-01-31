/// A protocol for defining strategies for handling response bodies.
///
/// Implement this protocol to create custom strategies for handling response bodies.
///
/// Example usage:
/// ```swift
/// public class SpecificStatusCodeDecodingStrategy: ResponseBodyDecodingStrategy {
///
///     public static func allowsEmptyContent(for statusCode: Int) -> Bool {
///         return statusCode == 204 // your own statusCode value
///     }
/// }
/// ```
public protocol ResponseBodyDecodingStrategy {
    /// Indicates whether the decoding should fail when no content is returned or not.
    ///
    /// Use this property in a custom strategy implementation (example below) to check against the response's
    /// `statusCode` and determine whether or not it should fail when receiving empty data.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether empty content is allowed.
    static func allowsEmptyContent(for statusCode: Int) -> Bool

    /// Validates the HTTP status code to determine if it is within the acceptable range.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether the status code is valid.
    static func validate(statusCode: Int) -> Bool
}
