extension ResponseErrorBody {
    public typealias Status400 = ResponseErrorBodyWrapper<Body, ValidateStatus400ErrorBodyStrategy>
    public typealias Status401 = ResponseErrorBodyWrapper<Body, ValidateStatus401ErrorBodyStrategy>
    public typealias Status403 = ResponseErrorBodyWrapper<Body, ValidateStatus403ErrorBodyStrategy>
    public typealias Status404 = ResponseErrorBodyWrapper<Body, ValidateStatus404ErrorBodyStrategy>
    public typealias Status410 = ResponseErrorBodyWrapper<Body, ValidateStatus410ErrorBodyStrategy>
    public typealias Status422 = ResponseErrorBodyWrapper<Body, ValidateStatus422ErrorBodyStrategy>
}
