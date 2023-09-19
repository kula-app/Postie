@testable import Postie
import XCTest

class ResponseBodyWrapperTests: XCTestCase {
    func testDecoding_responseDecoder_shouldDecode() throws {
        // Arrange
        class FooBodyStrategy: ResponseBodyDecodingStrategy {
            static var didCallAllowsEmptyContent = false
            static var didCallValidateStatus = false

            static func allowsEmptyContent(for _: Int) -> Bool {
                didCallAllowsEmptyContent = true
                return true
            }

            static func validate(statusCode _: Int) -> Bool {
                didCallValidateStatus = true
                return true
            }
        }
        struct Foo: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseBodyWrapper<Body, FooBodyStrategy> var body
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
        XCTAssertFalse(FooBodyStrategy.didCallAllowsEmptyContent)
        XCTAssertTrue(FooBodyStrategy.didCallValidateStatus)
    }

    func testDecoding_invalidStatusCode_shouldDecodeToNil() throws {
        // Arrange
        class FooBodyStrategy: ResponseBodyDecodingStrategy {
            static var didCallAllowsEmptyContent = false
            static var didCallValidateStatus = false

            static func allowsEmptyContent(for _: Int) -> Bool {
                didCallAllowsEmptyContent = true
                return true
            }

            static func validate(statusCode _: Int) -> Bool {
                didCallValidateStatus = true
                return false
            }
        }
        struct Foo: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseBodyWrapper<Body, FooBodyStrategy> var body
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
        XCTAssertFalse(FooBodyStrategy.didCallAllowsEmptyContent)
        XCTAssertTrue(FooBodyStrategy.didCallValidateStatus)
    }


    func testDecoding_nonResponseDecoder_shouldDirectlyDecodeBodyType() throws {
        // Arrange
        class FooBodyStrategy: ResponseBodyDecodingStrategy {
            static var didCallAllowsEmptyContent = false
            static var didCallValidateStatus = false

            static func allowsEmptyContent(for _: Int) -> Bool {
                didCallAllowsEmptyContent = true
                return false
            }

            static func validate(statusCode _: Int) -> Bool {
                didCallValidateStatus = true
                return false
            }
        }
        struct Foo: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseBodyWrapper<Body, FooBodyStrategy> var body
        }
        // Act
        let decoder = JSONDecoder()
        let response = try decoder.decode(Foo.self, from: "{\"body\":{\"foo\":\"value\"}}".data(using: .utf8)!)
        // Assert
        XCTAssertEqual(response.body, .init(foo: "value"))
    }

    func testDecoding_emptyResponseWithAllowingStrategy_shouldDecodeNil() throws {
        // Arrange
        class AllowsEmptyBodyStrategy: ResponseBodyDecodingStrategy {
            static var didCallAllowsEmptyContent = false
            static var didCallValidateStatus = false

            static func allowsEmptyContent(for _: Int) -> Bool {
                didCallAllowsEmptyContent = true
                return true
            }

            static func validate(statusCode _: Int) -> Bool {
                didCallValidateStatus = true
                return true
            }
        }
        struct AllowedResponse: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseBodyWrapper<Body, AllowsEmptyBodyStrategy> var body
        }
        // Act
        let decoder = ResponseDecoder()
        let httpUrlResponse = HTTPURLResponse(
            url: URL(string: "http://testing.local")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let data = "".data(using: .utf8)!
        let response = try decoder.decode(AllowedResponse.self, from: (data: data, response: httpUrlResponse))
        // Assert
        XCTAssertNil(response.body)
        XCTAssertTrue(AllowsEmptyBodyStrategy.didCallAllowsEmptyContent)
    }

    func testDecoding_emptyResponseWithDisallowingStrategy_shouldThrowDecodingError() async throws {
        // Arrange
        class DisallowsEmptyBodyStrategy: ResponseBodyDecodingStrategy {
            static var didCallAllowsEmptyContent = false
            static var didCallValidateStatus = false

            static func allowsEmptyContent(for _: Int) -> Bool {
                didCallAllowsEmptyContent = true
                return false
            }

            static func validate(statusCode _: Int) -> Bool {
                didCallValidateStatus = true
                return true
            }
        }
        struct DisallowedResponse: Decodable {
            struct Body: JSONDecodable, Equatable {
                var foo: String
            }

            @ResponseBodyWrapper<Body, DisallowsEmptyBodyStrategy> var body
        }
        // Act
        let decoder = ResponseDecoder()
        let httpUrlResponse = HTTPURLResponse(
            url: URL(string: "http://testing.local")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let data = "".data(using: .utf8)!
        await XCTAssertThrowsError(try decoder.decode(DisallowedResponse.self, from: (data: data, response: httpUrlResponse))) { error in
            switch error {
            case let DecodingError.dataCorrupted(context):
                XCTAssertEqual((context.underlyingError as? NSError)?.code, 3840)
            default:
                XCTFail()
            }
        }
        // Assert
        XCTAssertTrue(DisallowsEmptyBodyStrategy.didCallAllowsEmptyContent)
    }
}
