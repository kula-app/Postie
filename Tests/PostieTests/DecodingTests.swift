import XCTest
@testable import Postie

class DecodingTests: XCTestCase {

    func testDecodingHeaders_headerIsGivenAndConvertible_shouldCastedValue() throws {
        struct Response: APIResponse {
            @APIResponseHeader("x-next-page")
            public var nextPage: Int
        }
        let data = "{}".data(using: .utf8)!
        let headers: [AnyHashable: Any] = [
            "x-next-page": 123
        ]
        let bodyDecoder = JSONDecoder()
//        let decoder = HTTPResponseDecoder(headers: headers, bodyDecoder: bodyDecoder)
//        let decoded = try decoder.decode(Response.self, from: data)
//        XCTAssertEqual(decoded.nextPage, 123)
    }
}
