public struct ValidateStatus303BodyStrategy: ResponseBodyDecodingStrategy {
    public static func allowsEmptyContent(for _: Int) -> Bool {
        true
    }

    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.seeOther.rawValue
    }
}
