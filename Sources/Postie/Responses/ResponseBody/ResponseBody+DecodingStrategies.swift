public extension ResponseBody {
    typealias OptionalContent = ResponseBodyWrapper<Body, OptionalContentStrategy>

    typealias Status200 = ResponseBodyWrapper<Body, ValidateStatus200BodyStrategy>
    typealias Status201 = ResponseBodyWrapper<Body, ValidateStatus201BodyStrategy>
    typealias Status303 = ResponseBodyWrapper<Body, ValidateStatus303BodyStrategy>
}
