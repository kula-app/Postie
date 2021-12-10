@testable import Postie
import XCTest

private struct Response: Decodable {

    @ResponseHeader<DefaultHeaderStrategy>
    var authorization: String

    @ResponseHeader<DefaultHeaderStrategy>
    var length: Int

    @ResponseHeader<DefaultHeaderStrategy>
    var contentType: String

    @ResponseHeader<DefaultHeaderStrategyOptional>
    var optionalValue: String?
}

class ResponseHeaderCodingTests: XCTestCase {

    let response = HTTPURLResponse(url: URL(string: "http://example.local")!, statusCode: 200, httpVersion: nil, headerFields: [
        "authorization": "Bearer Token",
        "LENGTH": "123",
        "Content-Type": "application/json",
        "X-CUSTOM-HEADER": "second custom header"
    ])!

    func testDecoding_defaultStrategy_shouldDecodeCaseInSensitiveResponseHeaders() {
        let decoder = ResponseDecoder()
        guard let decoded = CheckNoThrow(try decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.authorization, "Bearer Token")
        XCTAssertEqual(decoded.length, 123)
    }

    func testDecoding_defaultStrategySeparatorInName_shouldDecodeToCamelCase() {
        let decoder = ResponseDecoder()
        guard let decoded = CheckNoThrow(try decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.contentType, "application/json")
    }

    func testDecoding_optionalValueNotGiven_shouldDecodeToNil() {
        let decoder = ResponseDecoder()
        guard let decoded = CheckNoThrow(try decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertNil(decoded.optionalValue)
    }

    func testDecoding_optionalValueGiven_shouldDecodeToValue() {
        let response = HTTPURLResponse(url: URL(string: "http://example.local")!, statusCode: 200, httpVersion: nil, headerFields: [
            "authorization": "Bearer Token",
            "LENGTH": "123",
            "Content-Type": "application/json",
            "X-Custom-Header": "a custom value",
            "optionalValue": "value"
        ])!
        let decoder = ResponseDecoder()
        guard let decoded = CheckNoThrow(try decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.optionalValue, "value")
    }
}
