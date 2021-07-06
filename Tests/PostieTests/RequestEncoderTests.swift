import XCTest
@testable import Postie

class RequestEncoderTests: XCTestCase {

    let baseURL = URL(string: "https://postie.local")!

    func testEncodePlain_bodyHasInvalidCoding_shouldThrowError() {
        struct Foo: PlainRequest {
            typealias Response = EmptyResponse
            var body: String
            var encoding: String.Encoding {
                .ascii
            }
        }
        let encoding: String.Encoding = .ascii
        let request = Foo(body: "🔥")
        let encoder = RequestEncoder(baseURL: baseURL)
        XCTAssertThrowsError(try encoder.encodePlain(request: request)) { error in
            switch error {
            case APIError.failedToEncodePlainText(let failedEncoding):
                XCTAssertEqual(failedEncoding, encoding)
            default:
                XCTFail()
            }
        }
    }
}
