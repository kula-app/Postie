import Combine
import Foundation

/// A class responsible for decoding HTTP responses into specified types.
///
/// The `ResponseDecoder` class provides functionality to decode HTTP responses into specified types.
/// It uses the `ResponseDecoding` decoder to perform the decoding process.
public class ResponseDecoder {
    /// Decodes an HTTP response into the specified type.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - from: A tuple containing the response data and the HTTP URL response.
    /// - Returns: The decoded value of the specified type.
    /// - Throws: An error if the decoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let decoder = ResponseDecoder()
    /// let decodedValue = try decoder.decode(MyType.self, from: (data: responseData, response: httpResponse))
    /// ```
    public func decode<T>(_ type: T.Type, from: (data: Data, response: HTTPURLResponse)) throws -> T where T: Decodable {
        let decoder = ResponseDecoding(response: from.response, data: from.data)
        return try T(from: decoder)
    }
}

/// Conformance to the `TopLevelDecoder` protocol.
extension ResponseDecoder: TopLevelDecoder {}
