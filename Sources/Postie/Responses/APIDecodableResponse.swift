public protocol APIDecodableResponse: APIRequest {

    associatedtype Content: Decodable

}
