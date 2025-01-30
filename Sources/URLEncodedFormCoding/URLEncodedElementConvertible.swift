import Foundation

/// Capable of converting to / from `URLEncodedElement`.
protocol URLEncodedElementConvertible {
    /// Converts self to `URLEncodedElement`.
    func convertToURLEncodedElement() throws -> URLEncodedElement
}

extension String: URLEncodedElementConvertible {
    /// See `URLEncodedElementConvertible`.
    func convertToURLEncodedElement() throws -> URLEncodedElement {
        .text(self)
    }
}

extension URL: URLEncodedElementConvertible {
    /// See `URLEncodedElementConvertible`.
    func convertToURLEncodedElement() throws -> URLEncodedElement {
        .text(self.absoluteString)
    }
}

extension FixedWidthInteger {
    /// See `URLEncodedElementConvertible`.
    func convertToURLEncodedElement() throws -> URLEncodedElement {
        .text(description)
    }
}

extension Int: URLEncodedElementConvertible {}
extension Int8: URLEncodedElementConvertible {}
extension Int16: URLEncodedElementConvertible {}
extension Int32: URLEncodedElementConvertible {}
extension Int64: URLEncodedElementConvertible {}
extension UInt: URLEncodedElementConvertible {}
extension UInt8: URLEncodedElementConvertible {}
extension UInt16: URLEncodedElementConvertible {}
extension UInt32: URLEncodedElementConvertible {}
extension UInt64: URLEncodedElementConvertible {}

extension BinaryFloatingPoint {
    /// See `URLEncodedElementConvertible`.
    func convertToURLEncodedElement() throws -> URLEncodedElement {
        .text("\(self)")
    }
}

extension Float: URLEncodedElementConvertible {}
extension Double: URLEncodedElementConvertible {}

extension Bool: URLEncodedElementConvertible {
    /// See `URLEncodedElementConvertible`.
    func convertToURLEncodedElement() throws -> URLEncodedElement {
        .text(description)
    }
}

extension Decimal: URLEncodedElementConvertible {
    /// See `URLEncodedElementConvertible`.
    func convertToURLEncodedElement() throws -> URLEncodedElement {
        .text(description)
    }
}
