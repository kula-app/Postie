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
        guard let responseDecoder = decoder as? ResponseDecoding else {
            self.wrappedValue = try Body(from: decoder)
            return
        }
        guard HTTPStatusCode.ok..<HTTPStatusCode.multipleChoices ~= responseDecoder.response.statusCode else {
            self.wrappedValue = nil
            return
        }
        if !responseDecoder.failsOnEmptyData, responseDecoder.data.isEmpty {
          self.wrappedValue = nil
          return
        }
        self.wrappedValue = try responseDecoder.decodeBody(to: Body.self)
    }
}

protocol ResponseBodyProtocol {}

extension ResponseBody: ResponseBodyProtocol {}
