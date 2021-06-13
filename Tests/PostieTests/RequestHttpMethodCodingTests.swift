import XCTest
@testable import Postie

fileprivate struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestHTTPMethod var method

}

class RequestHTTPMethodCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url")!

    func testEncoding_emptyMethod_shouldSetHttpMethodToGet() {
        let request = Request()
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, HTTPMethod.get.rawValue)
    }

    func testEncoding_methodSet_shouldUseSetHTTPMethod() {
        var request = Request()
        request.method = .post
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, HTTPMethod.post.rawValue)
    }

    func testEncoding_duplicateMethods_shouldUseFirstOccurence() {
        struct Request: Encodable {

            typealias Response = EmptyResponse

            @RequestHTTPMethod var method1 = .delete
            @RequestHTTPMethod var method2 = .connect

        }
        guard let urlRequest = encodeRequest(request: Request()) else {
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, HTTPMethod.connect.rawValue)
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
