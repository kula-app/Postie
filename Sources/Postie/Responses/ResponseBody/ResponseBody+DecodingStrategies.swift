extension ResponseBody {
    public typealias OptionalContent = ResponseBodyWrapper<Body, OptionalContentStrategy>

    public typealias Status200 = ResponseBodyWrapper<Body, ValidateStatus200BodyStrategy>
    public typealias Status201 = ResponseBodyWrapper<Body, ValidateStatus201BodyStrategy>
    public typealias Status303 = ResponseBodyWrapper<Body, ValidateStatus303BodyStrategy>
}
