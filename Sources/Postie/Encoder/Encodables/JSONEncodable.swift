/// A type that should encode itself to a JSON representation.
public typealias JSONEncodable = Encodable & JSONFormatProvider & JSONBodyProvider

public protocol JSONBodyProvider {

    associatedtype Body: Encodable

    var body: Body { get }

}
