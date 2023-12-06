public struct ValidateStatus303BodyStrategy: ResponseBodyDecodingStrategy {
    public static func allowsEmptyContent(for _: Int) -> Bool {
        return true
    }

    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.seeOther.rawValue
    }
}
