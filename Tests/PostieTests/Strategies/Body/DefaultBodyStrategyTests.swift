@testable import Postie
import XCTest

class DefaultBodyStrategyTests: XCTestCase {
    func testAllowsEmptyContent_shouldAlwaysBeFalse() {
        for statusCode in 100 ... 599 {
            XCTAssertFalse(DefaultBodyStrategy.allowsEmptyContent(for: statusCode))
        }
    }

    func testValidateStatusCode_statusBelow2XXRange_shouldBeValid() {
        for statusCode in 0 ..< 200 {
            XCTAssertFalse(DefaultBodyStrategy.validate(statusCode: statusCode))
        }
    }

    func testValidateStatusCode_statusIn2XXRange_shouldBeValid() {
        for statusCode in [200, 201, 202, 203, 204, 205, 206, 207, 208, 226] {
            XCTAssertTrue(DefaultBodyStrategy.validate(statusCode: statusCode))
        }
    }

    func testValidateStatusCode_statusGreaterThan2XXRange_shouldBeValid() {
        for statusCode in 300 ..< 599 {
            XCTAssertFalse(DefaultBodyStrategy.validate(statusCode: statusCode))
        }
    }
}
