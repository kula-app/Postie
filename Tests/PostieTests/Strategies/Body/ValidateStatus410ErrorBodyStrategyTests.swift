import XCTest

@testable import Postie

class ValidateStatus410ErrorBodyStrategyTests: XCTestCase {
    func testIsError_statusIs410_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus410ErrorBodyStrategy.isError(statusCode: 410))
    }

    func testIsError_statusIsNot410_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus410ErrorBodyStrategy.isError(statusCode: 999))
    }
}
