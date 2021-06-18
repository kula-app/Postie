import XCTest
@testable import Postie

class RequestPathParameterCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url")!

    func testEncoding_missingParameter_shouldNotBeReplacedInPath() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestPath var path = "/some-path/{unknown_id}/more-path"

        }
        let request = Request()
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url?.path, "/some-path/{unknown_id}/more-path")
    }

    func testEncoding_unnamedParameter_shouldReplaceValueInPathByVariableName() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestPath var path = "/some-path/{id}/more-path"
            @RequestPathParameter var id: Int

        }
        let request = Request(id: 123)
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url?.path, "/some-path/123/more-path")
    }

    func testEncoding_namedParameter_shouldReplaceValueInPathByVariableName() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestPath var path = "/some-path/{custom_id}/more-path"
            @RequestPathParameter(name: "custom_id") var otherId: Int
        }
        var request = Request()
        request.otherId = 456
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url?.path, "/some-path/456/more-path")
    }

    func testEncoding_multipleOccurencesSameKey_shouldReplaceAllOccurencesInPath() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestPath var path = "/some/{id}/and/more/{id}/later"
            @RequestPathParameter var id: Int

        }
        let request = Request(id: 123)
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url?.path, "/some/123/and/more/123/later")
    }

    func testEncoding_emptyPath_shouldIgnorePathParameters() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestPath var path = ""

            @RequestPathParameter var id: Int
            @RequestPathParameter var name: String
        }
        let request = Request(id: 1, name: "some_name")
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url?.path, "")
    }

    func testEncoding_stringParameter_shouldBePercentageEscaped() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestPath var path = "/{name}"
            @RequestPathParameter var name: String

        }
        let request = Request(name: "some name")
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url?.path, "/some%20name")
    }

    internal func encodeRequest<T: Encodable>(request: T, file: StaticString = #filePath, line: UInt = #line) -> URLRequest? {
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription, file: file, line: line)
            return nil
        }
        return encoded
    }
}
