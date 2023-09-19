import XCTest

// swiftlint:disable:next identifier_name
func CheckNoThrow<T>(
    _ expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = (#filePath),
    line: UInt = #line
) -> T? {
    // swiftlint:disable:next identifier_name
    var r: T?
    XCTAssertNoThrow(try {
        r = try expression()
    }(), message(), file: file, line: line)
    return r
}
