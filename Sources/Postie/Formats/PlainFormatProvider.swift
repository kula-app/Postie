/// A type that has a default format of form-url-encoding
public protocol PlainFormatProvider {

    /// Format of data, default extension is set to `.json`
    static var format: APIDataFormat { get }

}

extension PlainFormatProvider {

    public static var format: APIDataFormat {
        .plain
    }
}
