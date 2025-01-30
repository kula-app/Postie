import XCTest

@testable import Postie

class ValidateStatus303BodyStrategyTests: XCTestCase {
    func testAllowsEmptyContent_statusIs303_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus303BodyStrategy.allowsEmptyContent(for: 303))
    }

    func testAllowsEmptyContent_statusIsNot303_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus303BodyStrategy.allowsEmptyContent(for: 999))
    }

    func testValidate_statusIs303_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus303BodyStrategy.validate(statusCode: 303))
    }

    func testValidate_statusIsNot303_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus303BodyStrategy.validate(statusCode: 999))
    }
}
