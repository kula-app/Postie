import XCTest
@testable import Postie

fileprivate struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestPath var path

}

class RequestPathCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url/")!

    func testEncoding_emptyPath_shouldSetEmptyURLPath() {
        let request = Request()
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url, baseURL)
    }

    func testEncoding_pathWithLeadingSlashAndBaseURLWithPath_shouldBeValidURL() {
        let baseURL = URL(string: "https://local.url/prefix")!
        let request = Request(path: "/some-detail-path")
        guard let urlRequest = encodeRequest(request: request, baseURL: baseURL) else {
            return
        }
        XCTAssertEqual(urlRequest.url, URL(string: "https://local.url/prefix/some-detail-path")!)
    }

    func testEncoding_pathWithLeadingSlash_shouldBeValidURL() {
        let request = Request(path: "/some-detail-path")
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url, URL(string: "https://local.url/some-detail-path")!)
    }

    func testEncoding_pathWithoutLeadingSlashAndBaseURLWithPath_shouldBeValidURL() {
        let baseURL = URL(string: "https://local.url/prefix")!
        let request = Request(path: "some-detail-path")
        guard let urlRequest = encodeRequest(request: request, baseURL: baseURL) else {
            return
        }
        XCTAssertEqual(urlRequest.url, URL(string: "https://local.url/prefix/some-detail-path")!)
    }

    internal func encodeRequest<T: Encodable>(request: T, baseURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> URLRequest? {
        let encoder = RequestEncoder(baseURL: baseURL ?? self.baseURL)
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
