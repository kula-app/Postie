import XCTest
@testable import Postie

class RequestEncodingErrorTests: XCTestCase {

    func testErrorDescription_invalidBaseURL_shouldHaveCorrectDescription() {
        let error: Error = RequestEncodingError.invalidBaseURL
        XCTAssertEqual(error.localizedDescription, "Invalid base URL")
    }

    func testErrorDescription_failedToCreateURL_shouldHaveCorrectDescription() {
        let error: Error = RequestEncodingError.failedToCreateURL
        XCTAssertEqual(error.localizedDescription, "Failed to create URL")
    }

    func testErrorDescription_invalidCustomURL_shouldHaveCorrectDescription() {
        let url = URL(string: "https://domain.local")!
        let error: Error = RequestEncodingError.invalidCustomURL(url)
        XCTAssertEqual(error.localizedDescription, "Invalid custom URL: https://domain.local")
    }

    func testErrorDescription_invalidPathParameterName_shouldHaveCorrectDescription() {
        let name = "some name"
        let error: Error = RequestEncodingError.invalidPathParameterName(name)
        XCTAssertEqual(error.localizedDescription, "Invalid path parameter name: some name")
    }
}
