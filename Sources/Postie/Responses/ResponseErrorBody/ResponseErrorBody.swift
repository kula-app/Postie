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

/// A type alias for `ResponseErrorBodyWrapper` with a status code validation strategy for status code 400.
///
/// The `Status400` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `ValidateStatus400ErrorBodyStrategy`.
/// It represents the error response body of a request where the status code is expected to be 400.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody.Status400<MyErrorResponseType>
/// ```
public extension ResponseErrorBody {
    typealias Status400 = ResponseErrorBodyWrapper<Body, ValidateStatus400ErrorBodyStrategy>
}

/// A type alias for `ResponseErrorBodyWrapper` with a status code validation strategy for status code 401.
///
/// The `Status401` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `ValidateStatus401ErrorBodyStrategy`.
/// It represents the error response body of a request where the status code is expected to be 401.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody.Status401<MyErrorResponseType>
/// ```
public extension ResponseErrorBody {
    typealias Status401 = ResponseErrorBodyWrapper<Body, ValidateStatus401ErrorBodyStrategy>
}

/// A type alias for `ResponseErrorBodyWrapper` with a status code validation strategy for status code 403.
///
/// The `Status403` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `ValidateStatus403ErrorBodyStrategy`.
/// It represents the error response body of a request where the status code is expected to be 403.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody.Status403<MyErrorResponseType>
/// ```
public extension ResponseErrorBody {
    typealias Status403 = ResponseErrorBodyWrapper<Body, ValidateStatus403ErrorBodyStrategy>
}

/// A type alias for `ResponseErrorBodyWrapper` with a status code validation strategy for status code 404.
///
/// The `Status404` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `ValidateStatus404ErrorBodyStrategy`.
/// It represents the error response body of a request where the status code is expected to be 404.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody.Status404<MyErrorResponseType>
/// ```
public extension ResponseErrorBody {
    typealias Status404 = ResponseErrorBodyWrapper<Body, ValidateStatus404ErrorBodyStrategy>
}

/// A type alias for `ResponseErrorBodyWrapper` with a status code validation strategy for status code 410.
///
/// The `Status410` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `ValidateStatus410ErrorBodyStrategy`.
/// It represents the error response body of a request where the status code is expected to be 410.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody.Status410<MyErrorResponseType>
/// ```
public extension ResponseErrorBody {
    typealias Status410 = ResponseErrorBodyWrapper<Body, ValidateStatus410ErrorBodyStrategy>
}

/// A type alias for `ResponseErrorBodyWrapper` with a status code validation strategy for status code 422.
///
/// The `Status422` type alias provides a convenient way to use `ResponseErrorBodyWrapper` with the `ValidateStatus422ErrorBodyStrategy`.
/// It represents the error response body of a request where the status code is expected to be 422.
///
/// Example usage:
/// ```
/// let errorResponseBody: ResponseErrorBody.Status422<MyErrorResponseType>
/// ```
public extension ResponseErrorBody {
    typealias Status422 = ResponseErrorBodyWrapper<Body, ValidateStatus422ErrorBodyStrategy>
}
