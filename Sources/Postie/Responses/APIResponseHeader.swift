@propertyWrapper public struct APIResponseHeader<T>: Decodable {

    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    public var wrappedValue: T {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        fatalError()
    }

    public init(from decoder: Decoder) throws {
        fatalError()
    }
}
