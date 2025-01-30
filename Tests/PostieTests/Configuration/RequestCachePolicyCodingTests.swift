import XCTest

@testable import Postie

class RequestCachePolicyCodingTests: XCTestCase {
    let baseURL = URL(string: "https://local.url")!

    func testEncoding_cachePolicyIsNotDefined_shouldUseDefault() {
        // Arrange
        struct Request: Postie.Request {
            typealias Response = EmptyResponse
        }

        let request = Request()
        let encoder = RequestEncoder(baseURL: baseURL)

        // Act
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }

        // Assert
        XCTAssertEqual(encoded.cachePolicy, .useProtocolCachePolicy)
    }

    func testEncoding_cachePolicyIsDefined_shouldUseDefault() {
        // Arrange
        struct Request: Postie.Request {
            typealias Response = EmptyResponse

            @RequestCachePolicy var cachePolicy
        }

        let request = Request()
        let encoder = RequestEncoder(baseURL: baseURL)

        // Act
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }

        // Assert
        XCTAssertEqual(encoded.cachePolicy, .useProtocolCachePolicy)
    }

    func testEncoding_cachePolicyIsOverwritten_shouldBeSetInRequest() {
        // Arrange
        struct Request: Postie.Request {
            typealias Response = EmptyResponse

            @RequestCachePolicy var cachePolicy = .returnCacheDataDontLoad
        }

        let request = Request()
        let encoder = RequestEncoder(baseURL: baseURL)

        // Act
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }

        // Assert
        XCTAssertEqual(encoded.cachePolicy, .returnCacheDataDontLoad)
    }
}
