import Foundation

@propertyWrapper
public struct ResponseStatusCode: Decodable {
    public var wrappedValue: UInt16

    public var projectedValue: HTTPStatusCode? {
        HTTPStatusCode(rawValue: wrappedValue)
    }

    public init() {
        self.wrappedValue = 0
    }

    public init(wrappedValue: UInt16) {
        self.wrappedValue = wrappedValue
    }
}
