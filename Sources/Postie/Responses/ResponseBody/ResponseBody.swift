/// A type alias for `ResponseBodyWrapper` with a default body decoding strategy.
///
/// The `ResponseBody` type alias provides a convenient way to use `ResponseBodyWrapper` with the `DefaultBodyStrategy`.
/// It represents the response body of a request and uses the default decoding strategy to decode the response body.
///
/// Example usage:
/// ```
/// let responseBody: ResponseBody<MyResponseType>
/// ```
public typealias ResponseBody<Body: Decodable> = ResponseBodyWrapper<Body, DefaultBodyStrategy>
