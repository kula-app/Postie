// swiftlint:disable nesting type_body_length
@testable import Postie
import XCTest

class RequestCookiesCodingTests: XCTestCase {
    let baseURL = URL(string: "https://local.url")!
    let cookies = [
        HTTPCookie(properties: [
            .domain: "local.url",
            .path: "/some/path",
            .name: "key",
            .value: "value"
        ])!
    ]

    func testEncoding_cookies_shouldBeSetInHeaders() {
        struct Request: Postie.Request {
            typealias Response = EmptyResponse

            @RequestCookies var cookies
        }

        var request = Request()
        request.cookies = cookies

        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Cookie"), "key=value")
    }

    func testEncoding_emptyCookiesCustomHeader_shouldNotAffectExistingCookieHeaders() {
        struct Request: Postie.Request {
            typealias Response = EmptyResponse

            @RequestCookies var cookies

            @RequestHeader(name: "Cookie") var cookieHeader
        }

        var request = Request()
        request.cookieHeader = "some header"

        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Cookie"), "some header")
    }

    func testEncoding_cookiesAndCustomHeaders_shouldBeMergedIntoHeaders() {
        struct Request: Postie.Request {
            typealias Response = EmptyResponse

            @RequestCookies var cookies

            @RequestHeader(name: "Some-Header") var someHeader
        }

        var request = Request()
        request.cookies = cookies
        request.someHeader = "some header"

        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Cookie"), "key=value")
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Some-Header"), "some header")
    }

    func testEncoding_cookiesCustomHeader_shouldBeOverwrittenByCustomHeaders() {
        struct Request: Postie.Request {
            typealias Response = EmptyResponse

            @RequestCookies var cookies

            @RequestHeader(name: "Cookie") var cookieHeader
        }

        var request = Request()
        request.cookies = cookies
        request.cookieHeader = "some header"

        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encode(request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Cookie"), "some header")
    }
}

// swiftlint:enable nesting type_body_length
