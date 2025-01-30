import XCTest

@testable import Postie

class ResponseStatusCodeCodingTests: XCTestCase {
    func testDecoding_noStatusCodeVariable_shouldDecodeWithoutStatusCode() {
        struct Response: Decodable {}

        let response = HTTPURLResponse(url: URL(string: "http://example.local")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let decoder = ResponseDecoder()
        XCTAssertNoThrow(try decoder.decode(Response.self, from: (Data(), response)))
    }

    func testDecoding_singleStatusCodeVariable_shouldDecodeStatusCodeIntoVariable() {
        struct Response: Decodable {
            @ResponseStatusCode var statusCode
        }
        let response = HTTPURLResponse(url: URL(string: "http://example.local")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let decoder = ResponseDecoder()
        guard let decoded = CheckNoThrow(try decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.statusCode, 404)
    }

    func testDecoding_multipleStatusCodeVariables_shouldDecodeSameStatusCodeIntoAll() {
        struct Response: Decodable {
            @ResponseStatusCode var statusCode
            @ResponseStatusCode var statusCodeAgain
        }
        let response = HTTPURLResponse(url: URL(string: "http://example.local")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let decoder = ResponseDecoder()
        guard let decoded = CheckNoThrow(try decoder.decode(Response.self, from: (Data(), response))) else {
            return
        }
        XCTAssertEqual(decoded.statusCode, 200)
        XCTAssertEqual(decoded.statusCode, 200)
        XCTAssertEqual(decoded.statusCodeAgain, 200)
    }
}
