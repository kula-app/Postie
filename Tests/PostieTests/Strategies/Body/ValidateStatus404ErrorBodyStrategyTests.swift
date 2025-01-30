import XCTest

@testable import Postie

class ValidateStatus404ErrorBodyStrategyTests: XCTestCase {
    func testIsError_statusIs404_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus404ErrorBodyStrategy.isError(statusCode: 404))
    }

    func testIsError_statusIsNot404_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus404ErrorBodyStrategy.isError(statusCode: 999))
    }
}
