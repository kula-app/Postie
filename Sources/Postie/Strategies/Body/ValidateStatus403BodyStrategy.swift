public struct ValidateStatus403BodyStrategy: ResponseErrorBodyDecodingStrategy {
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.forbidden.rawValue
    }
}
