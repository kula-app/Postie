public struct ValidateStatus400BodyStrategy: ResponseErrorBodyDecodingStrategy {
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.badRequest.rawValue
    }
}
