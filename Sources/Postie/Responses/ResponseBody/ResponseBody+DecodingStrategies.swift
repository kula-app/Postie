extension ResponseBody {
    /// A type alias for `ResponseBodyWrapper` with an optional content strategy.
    ///
    /// The `OptionalContent` type alias provides a convenient way to use `ResponseBodyWrapper` with the `OptionalContentStrategy`.
    /// It represents the response body of a request where the content is optional.
    ///
    /// Example usage:
    /// ```
    /// @ResponseBody<Body>.OptionalContent var body: Body
    /// ```
    public typealias OptionalContent = ResponseBodyWrapper<Body, OptionalContentStrategy>

    /// A type alias for `ResponseBodyWrapper` with a status code validation strategy for status code 200.
    ///
    /// The `Status200` type alias provides a convenient way to use `ResponseBodyWrapper` with the `ValidateStatus200BodyStrategy`.
    /// It represents the response body of a request where the status code is expected to be 200.
    ///
    /// Example usage:
    /// ```
    /// @ResponseBody<Body>.Status200 var body: Body
    /// ```
    public typealias Status200 = ResponseBodyWrapper<Body, ValidateStatus200BodyStrategy>

    /// A type alias for `ResponseBodyWrapper` with a status code validation strategy for status code 201.
    ///
    /// The `Status201` type alias provides a convenient way to use `ResponseBodyWrapper` with the `ValidateStatus201BodyStrategy`.
    /// It represents the response body of a request where the status code is expected to be 201.
    ///
    /// Example usage:
    /// ```
    /// @ResponseBody<Body>.Status201 var body: Body
    /// ```
    public typealias Status201 = ResponseBodyWrapper<Body, ValidateStatus201BodyStrategy>

    /// A type alias for `ResponseBodyWrapper` with a status code validation strategy for status code 303.
    ///
    /// The `Status303` type alias provides a convenient way to use `ResponseBodyWrapper` with the `ValidateStatus303BodyStrategy`.
    /// It represents the response body of a request where the status code is expected to be 303.
    ///
    /// Example usage:
    /// ```
    /// @ResponseBody<Body>.Status303 var body: Body
    /// ```
    public typealias Status303 = ResponseBodyWrapper<Body, ValidateStatus303BodyStrategy>
}
