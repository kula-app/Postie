public protocol APIJSONEncodedRequest: APIRequest {

}

extension APIJSONEncodedRequest {

    public var format: APIRequestFormat {
        .json
    }
}
