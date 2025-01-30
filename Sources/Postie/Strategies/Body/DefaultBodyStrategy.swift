public struct DefaultBodyStrategy: ResponseBodyDecodingStrategy {
    public static func allowsEmptyContent(for _: Int) -> Bool {
        false
    }

    public static func validate(statusCode: Int) -> Bool {
        HTTPStatusCode.ok..<HTTPStatusCode.multipleChoices ~= statusCode
    }
}
