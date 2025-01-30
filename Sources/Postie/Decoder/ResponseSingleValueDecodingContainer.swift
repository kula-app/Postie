import Foundation

class ResponseSingleValueDecodingContainer: SingleValueDecodingContainer {
    let decoder: ResponseDecoding
    var codingPath: [CodingKey]

    init(decoder: ResponseDecoding, codingPath: [CodingKey]) {
        self.decoder = decoder
        self.codingPath = codingPath
    }

    func decodeNil() -> Bool {
        fatalError("not implemented")
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        if type == ResponseStatusCode.self {
            guard let response = ResponseStatusCode(wrappedValue: UInt16(decoder.response.statusCode)) as? T else {
                preconditionFailure("Failed to cast ResponseStatusCode to type: \(type)")
            }
            return response
        }
        let decoding = ResponseDecoding(response: decoder.response, data: decoder.data, codingPath: codingPath)
        return try T(from: decoding)
    }
}
