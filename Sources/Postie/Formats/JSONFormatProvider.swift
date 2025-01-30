/// A type that has a default format of form-url-encoding
public protocol JSONFormatProvider {
    /// Format of data, default extension is set to `.json`
    static var format: APIDataFormat { get }
}

extension JSONFormatProvider {
    public static var format: APIDataFormat {
        .json
    }
}
