@testable import Postie
import XCTest

class ValidateStatus403ErrorBodyStrategyTests: XCTestCase {
    func testIsError_statusIs403_shouldBeTrue() {
        XCTAssertTrue(ValidateStatus403ErrorBodyStrategy.isError(statusCode: 403))
    }

    func testIsError_statusIsNot403_shouldBeFalse() {
        XCTAssertFalse(ValidateStatus403ErrorBodyStrategy.isError(statusCode: 999))
    }
}
