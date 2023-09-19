public class OptionalContentStrategy: ResponseBodyDecodingStrategy {
    public static func allowsEmptyContent(for statusCode: Int) -> Bool {
        statusCode == 204
    }

    public static func validate(statusCode: Int) -> Bool {
        DefaultBodyStrategy.validate(statusCode: statusCode)
    }
}
