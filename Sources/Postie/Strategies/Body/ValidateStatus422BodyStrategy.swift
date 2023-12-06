public struct ValidateStatus422BodyStrategy: ResponseErrorBodyDecodingStrategy {
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.unprocessableEntity.rawValue
    }
}
