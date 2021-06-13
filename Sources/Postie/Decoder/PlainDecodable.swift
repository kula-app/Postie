/// A type that representing
// public typealias PlainDecodable = Decodable & PlainFormatProvider

public typealias PlainDecodable = String

extension PlainDecodable: PlainFormatProvider {

    public static var format: APIDataFormat {
        .plain
    }
}
