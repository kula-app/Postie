@testable import Postie
import XCTest

class ValidateStatus200BodyStrategyTests: XCTestCase {
    func testAllowsEmptyContent_statusIs200_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus200BodyStrategy.allowsEmptyContent(for: 200))
    }

    func testAllowsEmptyContent_statusIsNot200_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus200BodyStrategy.allowsEmptyContent(for: 999))
    }

    func testValidate_statusIs200_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus200BodyStrategy.validate(statusCode: 200))
    }

    func testValidate_statusIsNot200_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus200BodyStrategy.validate(statusCode: 999))
    }
}
