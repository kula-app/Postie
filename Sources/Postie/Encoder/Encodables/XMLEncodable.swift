/// A type that should encode itself to a JSON representation.
public typealias XMLEncodable = Encodable & XMLFormatProvider & XMLBodyProvider

public protocol XMLBodyProvider {

    associatedtype Body: Encodable

    var body: Body { get }

}
