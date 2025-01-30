public struct ValidateStatus200BodyStrategy: ResponseBodyDecodingStrategy {
    public static func allowsEmptyContent(for _: Int) -> Bool {
        false
    }

    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.ok.rawValue
    }
}
