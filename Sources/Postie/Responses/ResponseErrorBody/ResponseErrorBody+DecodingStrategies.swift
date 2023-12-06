public extension ResponseErrorBody {
    typealias Status400 = ResponseErrorBodyWrapper<Body, ValidateStatus400ErrorBodyStrategy>
    typealias Status401 = ResponseErrorBodyWrapper<Body, ValidateStatus401ErrorBodyStrategy>
    typealias Status403 = ResponseErrorBodyWrapper<Body, ValidateStatus403ErrorBodyStrategy>
    typealias Status404 = ResponseErrorBodyWrapper<Body, ValidateStatus404ErrorBodyStrategy>
    typealias Status410 = ResponseErrorBodyWrapper<Body, ValidateStatus410ErrorBodyStrategy>
    typealias Status422 = ResponseErrorBodyWrapper<Body, ValidateStatus422ErrorBodyStrategy>
}
