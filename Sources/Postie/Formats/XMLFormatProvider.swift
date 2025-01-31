import Foundation

/// A type that has a default format of xml
public protocol XMLFormatProvider {
    /// Format of data, default extension is set to `.xml`
    static var format: APIDataFormat { get }
}

extension XMLFormatProvider {
    public static var format: APIDataFormat {
        .xml
    }
}
