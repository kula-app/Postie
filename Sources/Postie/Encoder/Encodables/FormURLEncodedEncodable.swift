/// A type that can decode itself from an external form-url encoded representation.
public typealias FormURLEncodedEncodable = Encodable & FormURLEncodedFormatProvider & FormURLEncodedBodyProvider

public protocol FormURLEncodedBodyProvider {

    associatedtype Body: Encodable

    var body: Body { get }

}
