public struct ValidateStatus422ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.unprocessableEntity.rawValue
    }
}
