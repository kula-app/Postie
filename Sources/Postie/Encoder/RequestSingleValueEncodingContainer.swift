class RequestSingleValueEncodingContainer: SingleValueEncodingContainer {
    let encoder: RequestEncoding
    var codingPath: [CodingKey]

    init(encoder: RequestEncoding, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }

    func encodeNil() throws {
        fatalError("Encoding nil is not supported")
    }

    func encode<T>(_ value: T) throws where T: Encodable {
        fatalError("Encoding \(T.self) is not supported")
    }
}
