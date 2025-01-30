import XCTest

@testable import Postie

class RequestEncoderTests: XCTestCase {
    let baseURL = URL(string: "https://postie.local")!

    func testEncodePlain_bodyHasInvalidCoding_shouldThrowError() async {
        struct Foo: PlainRequest {
            typealias Response = EmptyResponse
            var body: String
            var encoding: String.Encoding {
                .ascii
            }
        }
        let encoding: String.Encoding = .ascii
        let request = Foo(body: "🔥")
        let encoder = RequestEncoder(baseURL: baseURL)
        await XCTAssertThrowsError(try encoder.encodePlain(request: request)) { error in
            switch error {
            case let APIError.failedToEncodePlainText(failedEncoding):
                XCTAssertEqual(failedEncoding, encoding)
            default:
                XCTFail("Unexpected error")
            }
        }
    }

    func testEncodeUrl_customUrlWithQueryItems_shouldBeIncludedInRequest() throws {
        // Arrange
        struct Foo: Request {
            typealias Response = EmptyResponse

            @RequestURL var url
        }
        var foo = Foo()
        foo.url = URL(string: "https://testing.local?field1=value")
        // Act
        let encoder = RequestEncoder(baseURL: baseURL)
        let request = try encoder.encode(foo)
        // Assert
        XCTAssertEqual(request.url, URL(string: "https://testing.local?field1=value"))
    }

    func testEncodeUrl_customUrlWithQueryAndOtherQueryItems_shouldAllBeIncludedInRequest() throws {
        // Arrange
        struct Foo: Request {
            typealias Response = EmptyResponse

            @RequestURL var url
            @QueryItem(name: "field2") var field2: String?
        }
        var foo = Foo()
        foo.url = URL(string: "https://testing.local?field1=value1")
        foo.field2 = "value2"
        // Act
        let encoder = RequestEncoder(baseURL: baseURL)
        let request = try encoder.encode(foo)
        // Assert
        XCTAssertEqual(request.url, URL(string: "https://testing.local?field1=value1&field2=value2"))
    }

    func testEncodeUrl_customUrlWithQueryAndSameQueryItems_shouldUseTheValueFromCustomUrlInRequest() throws {
        // Arrange
        struct Foo: Request {
            typealias Response = EmptyResponse

            @RequestURL var url
            @QueryItem(name: "field1") var field1: String?
        }
        var foo = Foo()
        foo.url = URL(string: "https://testing.local?field1=value1")
        foo.field1 = "value2"
        // Act
        let encoder = RequestEncoder(baseURL: baseURL)
        let request = try encoder.encode(foo)
        // Assert
        XCTAssertEqual(request.url, URL(string: "https://testing.local?field1=value1"))
    }
}
