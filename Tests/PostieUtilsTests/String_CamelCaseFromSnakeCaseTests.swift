import XCTest

@testable import PostieUtils

// swiftlint:disable:next type_name
final class String_CamelCaseFromSnakeCaseTests: XCTestCase {
    func testConversion_leadingUnderscore_shouldBePreserved() {
        XCTAssertEqual("_one_two_three".camelCaseFromSnakeCase, "_oneTwoThree")
    }

    func testConversion_multipleLeadingUnderscores_shouldBePreserved() {
        XCTAssertEqual("___one_two_three".camelCaseFromSnakeCase, "___oneTwoThree")
    }

    func testConversion_trailingUnderscore_shouldBePreserved() {
        XCTAssertEqual("one_two_three_".camelCaseFromSnakeCase, "oneTwoThree_")
    }

    func testConversion_multipleTrailingUnderscore_shouldBePreserved() {
        XCTAssertEqual("one_two_three___".camelCaseFromSnakeCase, "oneTwoThree___")
    }

    func testConversion_leadingTrailingUnderscore_shouldBePreserved() {
        XCTAssertEqual("_one_two_three_".camelCaseFromSnakeCase, "_oneTwoThree_")
    }

    func testConversion_multipleLeadingTrailingUnderscore_shouldBePreserved() {
        XCTAssertEqual("___one_two_three___".camelCaseFromSnakeCase, "___oneTwoThree___")
    }

    func testConversion_noUnderscores_shouldBeginLowercased() {
        XCTAssertEqual("Word".camelCaseFromSnakeCase, "word")
    }

    func testConversion_shouldBeginLowercased() {
        XCTAssertEqual("one_two_three".camelCaseFromSnakeCase, "oneTwoThree")
    }
}
