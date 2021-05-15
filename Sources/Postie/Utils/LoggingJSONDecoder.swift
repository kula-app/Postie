import Foundation
import os.log

class LoggingJSONDecoder: JSONDecoder {

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do {
            return try super.decode(type, from: data)
        } catch {
            os_log("Failed to decode JSON: %@\nReason: %@", type: .error, String(data: data, encoding: .utf8) ?? "nil", error.localizedDescription)
            throw error
        }
    }
}
