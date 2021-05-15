import Foundation

public protocol APIPostRequest: APIRequest, APIPayloadRequest {
}

extension APIPostRequest {

    public var httpMethod: String { "POST" }
    public var body: Data { Data() }

}
