/// A type which represents plain text
public typealias PlainDecodable = String

extension PlainDecodable: PlainFormatProvider {
    public static var format: APIDataFormat {
        .plain
    }
}
