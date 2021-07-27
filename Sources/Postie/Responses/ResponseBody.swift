public typealias ResponseBody<Body: Decodable> = ResponseBodyWrapper<Body, DefaultStrategy>

@propertyWrapper
public struct ResponseBodyWrapper<Body: Decodable, DecodingStrategy: ResponseBodyDecodingStrategy> {

    public var wrappedValue: Body?

    public init() {
        wrappedValue = nil
    }

    public init(wrappedValue: Body?) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseBodyWrapper: Decodable {

    public init(from decoder: Decoder) throws {
        guard let responseDecoder = decoder as? ResponseDecoding else {
            self.wrappedValue = try Body(from: decoder)
            return
        }
        guard HTTPStatusCode.ok..<HTTPStatusCode.multipleChoices ~= responseDecoder.response.statusCode else {
            self.wrappedValue = nil
            return
        }
        if DecodingStrategy.shouldAcceptEmptyDataAsNil && responseDecoder.data.isEmpty {
            self.wrappedValue = nil
            return
        }
        self.wrappedValue = try responseDecoder.decodeBody(to: Body.self)
    }
}

protocol ResponseBodyProtocol {}

extension ResponseBodyWrapper: ResponseBodyProtocol {}

public protocol ResponseBodyDecodingStrategy {

    static var shouldAcceptEmptyDataAsNil: Bool { get }

}

extension DefaultStrategy: ResponseBodyDecodingStrategy {

    public static var shouldAcceptEmptyDataAsNil: Bool { return false }

}

public class AcceptEmptyAsNilStrategy: ResponseBodyDecodingStrategy {

    public static var shouldAcceptEmptyDataAsNil: Bool { true }
}

extension ResponseBody {

    public typealias AcceptEmptyAsNil = ResponseBodyWrapper<Body, AcceptEmptyAsNilStrategy>

}
