import XCTest
@testable import PostieUtils

// swiftlint:disable:next type_name
final class String_CamelCaseToSnakeCaseTests: XCTestCase {

    func testConversion_leadingUnderscore_shouldBePreserved() {
        XCTAssertEqual("JSON123".camelCaseToSnakeCase, "json_123")
        XCTAssertEqual("JSON123Test".camelCaseToSnakeCase, "json_123_test")
        XCTAssertEqual("ThisIsAnAITest".camelCaseToSnakeCase, "this_is_an_ai_test")
        XCTAssertEqual("ThisIsATest".camelCaseToSnakeCase, "this_is_a_test")
        XCTAssertEqual("1234ThisIsATest".camelCaseToSnakeCase, "1234_this_is_a_test")
    }
}
