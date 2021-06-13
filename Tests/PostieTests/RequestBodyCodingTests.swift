import XCTest
@testable import Postie

class RequestBodyCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url")!

    func testEncoding_emptyJsonBody_shouldEncodeToEmptyJsonAndSetContentTypeHeader() {
        struct Foo: JSONEncodable {

            struct Body: Encodable {}
            struct Response: Decodable {}

            var body: Body

        }

        let request = Foo(body: Foo.Body())
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeJson(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "{}".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func testEncoding_customJsonContentTypeHeader_shouldUseCustomHeader() {
        struct Foo: JSONEncodable {

            struct Body: Encodable {}
            struct Response: Decodable {}

            var body: Body

            @RequestHeader(name: "Content-Type") var customContentTypeHeader
        }

        var request = Foo(body: Foo.Body())
        request.customContentTypeHeader = "postie-test"
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeJson(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "{}".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "postie-test")
    }

    func testEncoding_nonEmptyJsonBody_shouldEncodeToValidJsonAndSetContentTypeHeader() {
        struct Foo: JSONEncodable {

            struct Body: Encodable {
                var value: Int
            }
            struct Response: Decodable {}

            var body: Body

        }

        let request = Foo(body: Foo.Body(value: 123))
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeJson(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "{\"value\":123}".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func testEncoding_emptyFormURLEncodedBody_shouldEncodeToEmptyBodyAndSetContentTypeHeader() {
        struct Foo: FormURLEncodedEncodable {

            struct Body: Encodable {}
            struct Response: Decodable {}

            var body: Body

        }

        let request = Foo(body: Foo.Body())
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }

        XCTAssertEqual(encoded.httpBody, Data())
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
    }

    func testEncoding_customFormURLEncodedContentTypeHeader_shouldUseCustomHeader() {
        struct Foo: FormURLEncodedEncodable {

            struct Body: Encodable {}
            struct Response: Decodable {}

            var body: Body

            @RequestHeader(name: "Content-Type") var customContentTypeHeader
        }

        var request = Foo(body: Foo.Body())
        request.customContentTypeHeader = "postie-test"
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }

        XCTAssertEqual(encoded.httpBody, Data())
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "postie-test")
    }

    func testEncoding_nonEmptyFormURLEncodedBody_shouldEncodeToValidFormURLEncodedStringAndSetContentTypeHeader() {
        struct Foo: FormURLEncodedEncodable {

            struct Body: Encodable {
                var value: Int
                var others: String
            }
            struct Response: Decodable {}

            var body: Body

        }

        let request = Foo(body: Foo.Body(value: 123, others: "This escaped string"))
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "others=This%20escaped%20string&value=123".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
    }
}
