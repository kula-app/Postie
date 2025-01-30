import Foundation

@propertyWrapper
public struct RequestCachePolicy {

    public var wrappedValue: URLRequest.CachePolicy

    public init(wrappedValue: URLRequest.CachePolicy = .useProtocolCachePolicy) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: - Encodable

extension RequestCachePolicy: Encodable {
    public func encode(to encoder: any Encoder) throws {
        // This method needs to defined because `URLRequest.CachePolicy` does not conform to `Encodable`, but should never be called anyways
        preconditionFailure("\(Self.self).encode(to encoder:) should not be called")
    }
}
