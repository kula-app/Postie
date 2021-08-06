public struct DefaultBodyStrategy: ResponseBodyDecodingStrategy {

    public static var allowsEmptyContent: Bool {
        return false
    }

    public static var statusCode: Int?
}
