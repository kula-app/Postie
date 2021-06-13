import XCTest
@testable import Postie

fileprivate struct Foo: Encodable {

    typealias Response = EmptyResponse

    @RequestHeader
    var text: String

    @RequestHeader(name: "other_text")
    var text2: String

}

class RequestHeaderCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url")!

    func testEncoding_shouldEncodeUnnamedAndNamedRequestHeaders() {
        var request = Foo(text: "bar")
        request.text2 = "bar2"
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items["text"], "bar")
        XCTAssertEqual(items["other_text"], "bar2")
    }

    internal func encodeRequest<T: Encodable>(request: T, file: StaticString = #filePath, line: UInt = #line) -> [String: String]? {
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription, file: file, line: line)
            return nil
        }
        return encoded.allHTTPHeaderFields
    }
}
