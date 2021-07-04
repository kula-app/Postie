import XCTest
@testable import Postie

fileprivate struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestUrl var url

}

class RequestUrlCodingTests: XCTestCase {

    let baseURL = URL(string: "https://postie.local/")!

    func testEncoding_emptyPath_shouldSetEmptyURLPath() {
        let request = Request()
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url, baseURL)
    }

    func testEncoding_nonEmptyUrl_shouldSetURL() {
        let testUrl = URL(string: "https://postie2.local/customUrl")!
        var request = Request()
        request.url = testUrl
        guard let urlRequest = encodeRequest(request: request) else {
            return
        }
        XCTAssertEqual(urlRequest.url, testUrl)
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
