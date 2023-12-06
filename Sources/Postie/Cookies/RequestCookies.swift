import Foundation

@propertyWrapper
public struct RequestCookies {
    public var wrappedValue: [HTTPCookie]

    public init(wrappedValue: [HTTPCookie] = []) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: Encodable

extension RequestCookies: Encodable {
    public func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
