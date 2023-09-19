// swiftlint:disable nesting
import XCTest
@testable import Postie

private struct Foo: Encodable {

    typealias Response = EmptyResponse

    @RequestHeader
    var text: String

    @RequestHeader(name: "other_text")
    var text2: String

    @RequestHeader
    var optionalText: String?

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

    func testEncoding_optionalHeaderNil_shouldNotBeSet() {
        var request = Foo(text: "foo", optionalText: nil)
        request.text2 = "bar"
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items["text"], "foo")
        XCTAssertEqual(items["other_text"], "bar")
    }

    func testEncoding_optionalHeaderIsSet_shouldBeSet() {
        var request = Foo(text: "bar", optionalText: "optional")
        request.text2 = "bar2"
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items["text"], "bar")
        XCTAssertEqual(items["other_text"], "bar2")
        XCTAssertEqual(items["optionalText"], "optional")
    }

    func testEncoding_defaultValueHeaderIsGiven_shouldBeUsedIfNoneIsSet() {
        struct Foo: Encodable {

            typealias Response = EmptyResponse

            @RequestHeader(defaultValue: "some value")
            var defaultText: String?
        }

        let request = Foo()
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items["defaultText"], "some value")
    }

    func testEncoding_namedHeaderWithDefaultValueIsGiven_shouldBeUsedIfNoneIsSet() {
        struct Foo: Encodable {

            typealias Response = EmptyResponse

            @RequestHeader(name: "some key", defaultValue: "some value")
            var namedDefaultText: String?
        }

        let request = Foo()
        guard let items = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items["some key"], "some value")
    }

    internal func encodeRequest<T: Encodable>(request: T, file: StaticString = #filePath, line: UInt = #line) -> [String: String]? {
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription, file: file, line: line)
            return nil
        }
        return encoded.allHTTPHeaderFields
    }
}
// swiftlint:enable nesting
