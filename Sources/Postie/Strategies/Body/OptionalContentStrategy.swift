public class OptionalContentStrategy: ResponseBodyDecodingStrategy {

    public static func allowsEmptyContent(for statusCode: Int?) -> Bool {
        return statusCode == 204
    }
}
