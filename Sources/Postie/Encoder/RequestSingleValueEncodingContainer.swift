class RequestSingleValueEncodingContainer: SingleValueEncodingContainer {

    let encoder: RequestEncoding
    var codingPath: [CodingKey]

    init(encoder: RequestEncoding, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }

    func encodeNil() throws {
        fatalError()
    }

    func encode<T>(_ value: T) throws where T : Encodable {
        fatalError()
    }
}
