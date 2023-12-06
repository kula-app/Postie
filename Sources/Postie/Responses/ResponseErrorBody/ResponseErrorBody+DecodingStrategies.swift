public extension ResponseErrorBody {
    typealias Status400 = ResponseErrorBodyWrapper<Body, ValidateStatus400BodyStrategy>
    typealias Status401 = ResponseErrorBodyWrapper<Body, ValidateStatus401BodyStrategy>
    typealias Status403 = ResponseErrorBodyWrapper<Body, ValidateStatus403BodyStrategy>
    typealias Status404 = ResponseErrorBodyWrapper<Body, ValidateStatus404BodyStrategy>
    typealias Status410 = ResponseErrorBodyWrapper<Body, ValidateStatus410BodyStrategy>
    typealias Status422 = ResponseErrorBodyWrapper<Body, ValidateStatus422BodyStrategy>
}

