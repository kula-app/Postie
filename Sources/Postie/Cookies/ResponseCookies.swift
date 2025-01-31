import Foundation

/// A property wrapper that provides a convenient way to handle HTTP cookies in a response.
///
/// Example usage:
/// ```
/// @ResponseCookies var cookies: [HTTPCookie]
/// ```
/// This property wrapper can be used to manage HTTP cookies in a response.
@propertyWrapper
public struct ResponseCookies {
    /// The wrapped value representing an array of `HTTPCookie` objects.
    ///
    /// This property holds the array of `HTTPCookie` objects that are managed by this property wrapper.
    public var wrappedValue: [HTTPCookie]

    /// Initializes a new instance of `ResponseCookies` with an optional array of `HTTPCookie` objects.
    ///
    /// - Parameter wrappedValue: An array of `HTTPCookie` objects. Defaults to an empty array.
    ///
    /// Example usage:
    /// ```
    /// @ResponseCookies var cookies: [HTTPCookie] = [cookie1, cookie2]
    /// ```
    public init(wrappedValue: [HTTPCookie] = []) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseCookies: Decodable {
    /// Initializes a new instance of `ResponseCookies` by decoding from the given decoder.
    ///
    /// This initializer should only be used with a `ResponseDecoding` decoder.
    /// If the decoder is not a `ResponseDecoding` instance, a runtime failure will occur.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: `APIError.invalidResponse` if the response is invalid.
    public init(from decoder: Decoder) throws {
        // Check if the decoder is response decoder, otherwise throw fatal error, because this property wrapper must use the correct decoder
        guard let responseDecoding = decoder as? ResponseDecoding else {
            preconditionFailure("\(Self.self) can only be used with \(ResponseDecoding.self)")
        }
        guard let url = responseDecoding.response.url, let allHeaderFields = responseDecoding.response.allHeaderFields as? [String: String] else {
            throw APIError.invalidResponse
        }
        self.wrappedValue = HTTPCookie.cookies(withResponseHeaderFields: allHeaderFields, for: url)
    }
}
