/// A type that has a default format of form-url-encoding
public protocol FormURLEncodedFormatProvider {
    /// Format of data, default extension is set to `.formURLEncoded`
    static var format: APIDataFormat { get }
}

extension FormURLEncodedFormatProvider {
    public static var format: APIDataFormat {
        .formURLEncoded
    }
}
