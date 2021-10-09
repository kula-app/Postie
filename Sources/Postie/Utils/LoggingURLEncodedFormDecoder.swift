import Foundation
import os.log
import URLEncodedFormCoding

class LoggingURLEncodedFormDecoder: URLEncodedFormDecoder {

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        do {
            return try super.decode(type, from: data)
        } catch {
            os_log("Failed to decode form-url-encoded data: %@\nReason: %@\nDetails: %@", type: .error, String(data: data, encoding: .utf8) ?? "nil", error.localizedDescription, String(describing: error))
            throw error
        }
    }
}
