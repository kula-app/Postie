// swiftlint:disable nesting
@testable import Postie
import XCTest

class ResponseErrorBodyWrapperTests: XCTestCase {
    func testDecoding_responseDecoder_shouldDecode() throws {
        // Arrange
        class FooBodyStrategy: ResponseErrorBodyDecodingStrategy {
            static var didCallIsError = false

            static func isError(statusCode: Int) -> Bool {
                didCallIsError = true
                return true
            }
        }
        struct Foo: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseErrorBodyWrapper<Body, FooBodyStrategy> var body
        }
        // Act
        let decoder = ResponseDecoder()
        let httpUrlResponse = HTTPURLResponse(
            url: URL(string: "http://testing.local")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let data = "{\"foo\":\"value\"}".data(using: .utf8)!
        let response = try decoder.decode(Foo.self, from: (data: data, response: httpUrlResponse))
        // Assert
        XCTAssertEqual(response.body, Foo.Body(foo: "value"))
        XCTAssertTrue(FooBodyStrategy.didCallIsError)
    }

    func testDecoding_invalidStatusCode_shouldDecodeToNil() throws {
        // Arrange
        class FooBodyStrategy: ResponseErrorBodyDecodingStrategy {
            static var didCallIsError = false

            static func isError(statusCode _: Int) -> Bool {
                didCallIsError = true
                return false
            }
        }
        struct Foo: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseErrorBodyWrapper<Body, FooBodyStrategy> var body
        }
        // Act
        let decoder = ResponseDecoder()
        let httpUrlResponse = HTTPURLResponse(
            url: URL(string: "http://testing.local")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let data = "{\"foo\":\"value\"}".data(using: .utf8)!
        let response = try decoder.decode(Foo.self, from: (data: data, response: httpUrlResponse))
        // Assert
        XCTAssertNil(response.body)
        XCTAssertTrue(FooBodyStrategy.didCallIsError)
    }

    func testDecoding_nonResponseDecoder_shouldDirectlyDecodeBodyType() throws {
        // Arrange
        class FooBodyStrategy: ResponseErrorBodyDecodingStrategy {
            static var didCallIsError = false

            static func isError(statusCode _: Int) -> Bool {
                didCallIsError = true
                return false
            }
        }
        struct Foo: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseErrorBodyWrapper<Body, FooBodyStrategy> var body
        }
        // Act
        let decoder = JSONDecoder()
        let response = try decoder.decode(Foo.self, from: "{\"body\":{\"foo\":\"value\"}}".data(using: .utf8)!)
        // Assert
        XCTAssertEqual(response.body, .init(foo: "value"))
    }
}
// swiftlint:enable nesting
