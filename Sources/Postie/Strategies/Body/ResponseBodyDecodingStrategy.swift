public protocol ResponseBodyDecodingStrategy {

    ///
    /// Use this property in a custom strategy implementation (example below) to check against the response's `statusCode` and determine wether or not it should fail when receiving empty data.
    ///
    /// ```swift
    /// public class SpecificStatusCodeDecodingStrategy: ResponseBodyDecodingStrategy {
    ///
    ///     public static func allowsEmptyContent(for statusCode: Int? = nil) -> Bool {
    ///         return statusCode == // your own statusCode value
    ///     }
    /// }
    ///

    /// Indicates wether the decoding should fail when no content is returned or not.
    static func allowsEmptyContent(for statusCode: Int?) -> Bool
}
