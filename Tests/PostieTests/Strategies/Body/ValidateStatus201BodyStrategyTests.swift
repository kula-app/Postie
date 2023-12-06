@testable import Postie
import XCTest

class ValidateStatus201BodyStrategyTests: XCTestCase {
    func testAllowsEmptyContent_statusIs201_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus201BodyStrategy.allowsEmptyContent(for: 201))
    }

    func testAllowsEmptyContent_statusIsNot201_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus201BodyStrategy.allowsEmptyContent(for: 999))
    }

    func testValidate_statusIs201_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus201BodyStrategy.validate(statusCode: 201))
    }

    func testValidate_statusIsNot201_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus201BodyStrategy.validate(statusCode: 999))
    }
}
