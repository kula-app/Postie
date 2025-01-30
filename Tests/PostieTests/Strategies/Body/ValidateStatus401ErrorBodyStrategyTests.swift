import XCTest

@testable import Postie

class ValidateStatus401ErrorBodyStrategyTests: XCTestCase {
    func testIsError_statusIs401_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus401ErrorBodyStrategy.isError(statusCode: 401))
    }

    func testIsError_statusIsNot401_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus401ErrorBodyStrategy.isError(statusCode: 999))
    }
}
