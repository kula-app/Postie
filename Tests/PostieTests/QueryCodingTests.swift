import XCTest
@testable import Postie

fileprivate struct Foo: Encodable {

    typealias Response = EmptyResponse

    @QueryItem
    var text: String

    @QueryItem(name: "other_text")
    var text2: String

    @QueryItem
    var optionalText: String?

}

class QueryCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url")!

    func testEncoding_shouldEncodeUnnamedQueryItem() {
        var request = Foo(text: "bar")
        request.text2 = "bar2"
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.contains(URLQueryItem(name: "text", value: "bar")))
    }

    func testEncoding_shouldEncodeNamedQueryItem() {
        var request = Foo(text: "bar")
        request.text2 = "bar2"
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.contains(URLQueryItem(name: "other_text", value: "bar2")))
    }

    func testEncoding_optionalQueryItemNil_shouldNotBeAddedToQuery() {
        let request = Foo(text: "bar", optionalText: nil)
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 2)
        XCTAssertFalse(items.contains(where: { $0.name == "optionalText" }))
    }

    func testEncoding_optionalQueryItemIsSet_shouldBeAddedToQuery() {
        let request = Foo(text: "bar", optionalText: "optional")
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 3)
        XCTAssertTrue(items.contains(URLQueryItem(name: "optionalText", value: "optional")))
    }

    internal func encodeRequest<T: Encodable>(request: T, file: StaticString = #filePath, line: UInt = #line) -> [URLQueryItem]? {
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription, file: file, line: line)
            return nil
        }
        guard let url = encoded.url else {
            XCTFail("Request does not contain URL", file: file, line: line)
            return nil
        }
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true), let items = comps.queryItems else {
            XCTFail("Failed to decompose URL", file: file, line: line)
            return nil
        }
        return items
    }
}
