import Foundation

/// A type alias for `ResponseErrorBodyWrapper` with a default error body decoding strategy.
///
/// The `ResponseErrorBody` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `DefaultErrorBodyStrategy`.
/// It represents the error response body of a request and uses the default decoding strategy to decode the error response body.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody<MyErrorResponseType>
/// ```
public typealias ResponseErrorBody<Body: Decodable> = ResponseErrorBodyWrapper<Body, DefaultErrorBodyStrategy>
