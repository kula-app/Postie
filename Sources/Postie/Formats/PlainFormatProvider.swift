/// A type that has a default format of plain text
public protocol PlainFormatProvider {
    /// Format of data, default extension is set to `.plain`
    static var format: APIDataFormat { get }
}

extension PlainFormatProvider {
    /// Default implementation is `.plain`
    public static var format: APIDataFormat {
        .plain
    }
}
