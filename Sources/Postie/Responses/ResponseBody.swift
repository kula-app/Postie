@propertyWrapper
public struct ResponseBody<Body: Decodable> {

    public var wrappedValue: Body?

    public init() {
        wrappedValue = nil
    }

    public init(wrappedValue: Body?) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseBody: Decodable {

    public init(from decoder: Decoder) throws {
        guard let decoder = decoder as? ResponseDecoding else {
            self.wrappedValue = try Body(from: decoder)
            return
        }
        guard HTTPStatusCode.ok..<HTTPStatusCode.multipleChoices ~= decoder.response.statusCode else {
            self.wrappedValue = nil
            return
        }
        self.wrappedValue = try decoder.decodeBody(to: Body.self)
    }
}

protocol ResponseBodyProtocol {}

extension ResponseBody: ResponseBodyProtocol {}
