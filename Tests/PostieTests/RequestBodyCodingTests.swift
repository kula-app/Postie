@testable import Postie
import XCTest

class RequestBodyCodingTests: XCTestCase {

    let baseURL = URL(string: "https://local.url")!

    func testEncoding_emptyJsonBody_shouldEncodeToEmptyJsonAndSetContentTypeHeader() {
        struct Foo: JSONEncodable {

            struct Body: Encodable {}
            typealias Response = EmptyResponse

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
            typealias Response = EmptyResponse

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

            typealias Response = EmptyResponse

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
        XCTAssertEqual(encoded.httpBody, #"{"value":123}"#.data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func testEncoding_nonEmptyJSONBody_shouldEncodeToValidSnakeCaseJSON() {
        struct Foo: JSONEncodable {

            struct Body: Encodable {
                var someValue: Int
                var someOtherValue: String
            }

            typealias Response = EmptyResponse

            var body: Body
        }

        let request = Foo(body: Foo.Body(someValue: 123, someOtherValue: "Bar"))
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeJson(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, #"{"some_other_value":"Bar","some_value":123}"#.data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func testEncoding_nonEmptyJSONBody_shouldEncodeToValidCamelCaseJSON() {
        struct Foo: JSONEncodable {

            struct Body: Encodable {
                var someValue: Int
                var someOtherValue: String
            }

            typealias Response = EmptyResponse

            var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
                return .useDefaultKeys
            }

            var body: Body
        }

        let request = Foo(body: Foo.Body(someValue: 123, someOtherValue: "Bar"))
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeJson(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, #"{"someValue":123,"someOtherValue":"Bar"}"#.data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func testEncoding_emptyFormURLEncodedBody_shouldEncodeToEmptyBodyAndSetContentTypeHeader() {
        struct Foo: FormURLEncodedEncodable {

            struct Body: Encodable {}
            typealias Response = EmptyResponse

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
            typealias Response = EmptyResponse

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

            typealias Response = EmptyResponse

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

    func testEncoding_nonEmptyPlainTextBody_shouldEncodeUsingDefaultEncoding() {
        struct Foo: PlainEncodable {

            typealias Response = EmptyResponse

            var body: String
        }

        let request = Foo(body: "some string")
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodePlain(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "some string".data(using: .utf8)!)
    }

    func testEncoding_nonEmptyPlainTextBodyCustomEncoding_shouldEncodeUsingCustomEncoding() {
        struct Foo: PlainEncodable {

            typealias Response = EmptyResponse

            var body: String
            var encoding: String.Encoding = .utf16
        }

        let request = Foo(body: "some string")
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodePlain(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "some string".data(using: .utf16)!)
    }

    // MARK: - XML

    func testEncoding_emptyXMLBody_shouldEncodeToSingleClosedXMLTagAndSetContentTypeHeader() {
        struct Foo: XMLEncodable {

            struct Body: Encodable {}
            typealias Response = EmptyResponse

            var body: Body
        }

        let request = Foo(body: Foo.Body())
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeXML(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "<Body />".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "text/xml")
    }

    func testEncoding_customXMLContentTypeHeader_shouldUseCustomHeader() {
        struct Foo: XMLEncodable {

            struct Body: Encodable {}
            typealias Response = EmptyResponse

            var body: Body

            @RequestHeader(name: "Content-Type") var customContentTypeHeader
        }

        var request = Foo(body: Foo.Body())
        request.customContentTypeHeader = "postie-test"
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeXML(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "<Body />".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "postie-test")
    }

    func testEncoding_nonEmptyXMLBody_shouldEncodeToValidXMLAndSetContentTypeHeader() {
        struct Foo: XMLEncodable {

            struct Body: Encodable {
                var value: Int
            }

            typealias Response = EmptyResponse

            var body: Body
        }

        let request = Foo(body: Foo.Body(value: 123))
        let encoder = RequestEncoder(baseURL: baseURL)
        let encoded: URLRequest
        do {
            encoded = try encoder.encodeXML(request: request)
        } catch {
            XCTFail("Failed to encode: " + error.localizedDescription)
            return
        }
        XCTAssertEqual(encoded.httpBody, "<Body><value>123</value></Body>".data(using: .utf8)!)
        XCTAssertEqual(encoded.value(forHTTPHeaderField: "Content-Type"), "text/xml")
    }
}
