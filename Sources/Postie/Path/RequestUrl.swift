import Foundation

@propertyWrapper
public struct RequestUrl: Encodable {

    public var wrappedValue: URL?

    public init(wrappedValue: URL? = nil) {
        self.wrappedValue = wrappedValue
    }
}
