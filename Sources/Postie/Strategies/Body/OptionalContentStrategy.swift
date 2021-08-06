public class OptionalContentStrategy: ResponseBodyDecodingStrategy {

    public static var allowsEmptyContent: Bool {
        return statusCode == 204
    }

    public static var statusCode: Int?
}
