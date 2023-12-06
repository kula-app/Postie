public struct ValidateStatus401BodyStrategy: ResponseErrorBodyDecodingStrategy {
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.unauthorized.rawValue
    }
}
