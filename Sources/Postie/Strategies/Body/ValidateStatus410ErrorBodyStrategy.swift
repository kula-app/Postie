public struct ValidateStatus410ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.gone.rawValue
    }
}
