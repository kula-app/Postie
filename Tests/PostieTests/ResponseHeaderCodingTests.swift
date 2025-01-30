import XCTest

@testable import Postie

private struct Response: Decodable {
    @ResponseHeader<DefaultHeaderStrategy>
    var authorization: String

    @ResponseHeader<DefaultHeaderStrategy>
    var length: Int

    @ResponseHeader<DefaultHeaderStrategy>
    var contentType: String

    @ResponseHeader<DefaultHeaderStrategyOptional>
    var optionalStringValue: String?

    @ResponseHeader<DefaultHeaderStrategyOptional>
    var optionalIntValue: Int?
}

class ResponseHeaderCodingTests: XCTestCase {
    let response = HTTPURLResponse(
        url: URL(string: "http://example.local")!, statusCode: 200, httpVersion: nil,
        headerFields: [
            "authorization": "Bearer Token",
            "LENGTH": "123",
            "Content-Type": "application/json",
            "X-CUSTOM-HEADER": "second custom header",
        ])!

    func testDecoding_defaultStrategy_shouldDecodeCaseInSensitiveResponseHeaders() {
        let decoder = ResponseDecoder()
        guard let decoded = try CheckNoThrow(decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.authorization, "Bearer Token")
        XCTAssertEqual(decoded.length, 123)
    }

    func testDecoding_defaultStrategySeparatorInName_shouldDecodeToCamelCase() {
        let decoder = ResponseDecoder()
        guard let decoded = try CheckNoThrow(decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.contentType, "application/json")
    }

    func testDecoding_optionalStringValueNotGiven_shouldDecodeToNil() {
        let decoder = ResponseDecoder()
        guard let decoded = try CheckNoThrow(decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertNil(decoded.optionalStringValue)
    }

    func testDecoding_optionalIntValueNotGiven_shouldDecodeToNil() {
        let decoder = ResponseDecoder()
        guard let decoded = try CheckNoThrow(decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertNil(decoded.optionalIntValue)
    }

    func testDecoding_optionalStringValueGiven_shouldDecodeToValue() {
        let response = HTTPURLResponse(
            url: URL(string: "http://example.local")!, statusCode: 200, httpVersion: nil,
            headerFields: [
                "authorization": "Bearer Token",
                "LENGTH": "123",
                "Content-Type": "application/json",
                "X-Custom-Header": "a custom value",
                "optionalStringValue": "value",
            ])!
        let decoder = ResponseDecoder()
        guard let decoded = try CheckNoThrow(decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.optionalStringValue, "value")
    }

    func testDecoding_optionalIntValueGiven_shouldDecodeToValue() {
        let response = HTTPURLResponse(
            url: URL(string: "http://example.local")!, statusCode: 200, httpVersion: nil,
            headerFields: [
                "authorization": "Bearer Token",
                "LENGTH": "123",
                "Content-Type": "application/json",
                "X-Custom-Header": "a custom value",
                "optionalIntValue": "10",
            ])!
        let decoder = ResponseDecoder()
        guard let decoded = try CheckNoThrow(decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.optionalIntValue, 10)
    }
}
