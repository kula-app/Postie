// swiftlint:disable nesting
import Postie
import PostieMock
import XCTest

class HTTPAPIClientE2EAsyncAwaitTests: XCTestCase {
    let baseURL = URL(string: "https://local.test")!

    func testSending_queryItems_shouldBeInRequestURI() async throws {
        struct Request: Postie.Request {
            struct Response: Decodable {}

            @QueryItem(name: "custom_name") var name: String
            @QueryItem var value: Int
            @QueryItem var optionalGivenValue: Bool?
            @QueryItem var optionalNilValue: Bool?
        }
        let stubResponse: (data: Data, response: URLResponse) = (
            data: Data(),
            response: HTTPURLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        var requestedURL: URL?
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse) { request in
            requestedURL = request.url
        }

        // Send request
        var request = Request(value: 321)
        request.name = "This custom name"
        request.optionalGivenValue = true
        _ = try await sendTesting(request: request, session: stubSession) { client, request in
            try await client.send(request)
        }

        // Assert request URL
        XCTAssertEqual(requestedURL, URL(
            string: "?custom_name=This%20custom%20name&value=321&optionalGivenValue=true",
            relativeTo: baseURL
        )!.absoluteURL)
    }

    func testSending_requestHeader_shouldBeInRequestHeaders() async throws {
        struct Request: Postie.Request {
            struct Response: Decodable {}

            @RequestHeader(name: "custom_name") var name
            @RequestHeader var value: Int
            @RequestHeader var optionalNilValue: Bool?
            @RequestHeader var optionalGivenValue: Bool?
        }
        let stubResponse: (data: Data, response: URLResponse) = (
            data: Data(),
            response: HTTPURLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        var requestHeaders: [String: String]?
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse) { request in
            requestHeaders = request.allHTTPHeaderFields
        }

        // Send request
        var request = Request(value: 321)
        request.name = "this custom name"
        request.optionalGivenValue = true
        _ = try await sendTesting(request: request, session: stubSession) { client, request in
            try await client.send(request)
        }

        // Assert request URL
        XCTAssertEqual(requestHeaders, [
            "custom_name": "this custom name",
            "value": "321",
            "optionalGivenValue": "true"
        ])
    }

    func testSending_requestBody_shouldBeInRequest() async throws {
        struct Request: JSONRequest {
            struct Body: Encodable {
                var value: Int
            }

            struct Response: Decodable {}

            var body: Body
        }
        let stubResponse: (data: Data, response: URLResponse) = (
            data: Data(),
            response: HTTPURLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        var requestBody: Data?
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse) { request in
            requestBody = request.httpBody
        }

        // Send request
        _ = try await sendTesting(request: Request(body: .init(value: 321)), session: stubSession) { client, request in
            try await client.send(request)
        }

        // Assert request URL
        XCTAssertEqual(requestBody, "{\"value\":321}".data(using: .utf8)!)
    }

    func testSending_PlainResponse_shouldDecodeResponse() async throws {
        struct Request: Postie.Request {
            struct Response: Decodable {
                @ResponseStatusCode var statusCode
                @ResponseBody<PlainDecodable> var body
            }
        }

        // Prepare response stub
        let stubResponse: (data: Data, response: URLResponse) = (
            data: """
            this is random unformatted plain text
            """.data(using: .utf8)!,
            response: HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse)

        // Send request
        let response = try await sendTesting(request: Request(), session: stubSession) { client, request in
            try await client.send(request)
        }
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.body, "this is random unformatted plain text")
    }

    func testSending_JSONResponse_shouldDecodeResponse() async throws {
        struct Request: Postie.Request {
            struct Response: Decodable {
                struct Body: JSONDecodable {
                    var value: String
                }

                @ResponseStatusCode var statusCode
                @ResponseBody<Body> var body
            }
        }

        // Prepare response stub
        let stubResponse: (data: Data, response: URLResponse) = (
            data: """
            {
                "value": "response value"
            }
            """.data(using: .utf8)!,
            response: HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse)

        // Send request
        let response = try await sendTesting(request: Request(), session: stubSession) { client, request in
            try await client.send(request)
        }
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.value, "response value")
    }

    func testSending_JSONArrayResponse_shouldDecodeResponseItems() async throws {
        struct Request: Postie.Request {
            struct Response: Decodable {
                struct BodyItem: JSONDecodable, Equatable {
                    var value: String
                }

                typealias Body = [BodyItem]

                @ResponseStatusCode var statusCode
                @ResponseBody<Body> var body
            }
        }

        // Prepare response stub
        let stubResponse: (data: Data, response: URLResponse) = (
            data: """
            [
                {
                    "value": "response value1"
                },
                {
                    "value": "response value2"
                }
            ]
            """.data(using: .utf8)!,
            response: HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse)

        // Send request
        let response = try await sendTesting(request: Request(), session: stubSession) { client, request in
            try await client.send(request)
        }
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.count, 2)
        XCTAssertEqual(response.body?[0], Request.Response.BodyItem(value: "response value1"))
        XCTAssertEqual(response.body?[1], Request.Response.BodyItem(value: "response value2"))
    }

    func testSending_invalidResponse_shouldThrowError() async {
        struct Request: Postie.Request {
            struct Response: JSONDecodable {
                struct Body: Decodable {}
            }
        }

        let stubResponse: (data: Data, response: URLResponse) = (
            data: Data(),
            response: URLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )
        let stubSession = URLSessionAsyncAwaitStub(response: stubResponse)
        await XCTAssertThrowsError(
            try await sendTesting(request: Request(), session: stubSession) { client, request in
                try await client.send(request)
            },
            APIError.invalidResponse.localizedDescription
        )
    }
}

extension HTTPAPIClientE2EAsyncAwaitTests {
    func sendTesting<Request: Postie.Request>(
        request: Request, session: URLSessionProvider,
        _ send: (HTTPAPIClient, Request) async throws -> Request.Response
    ) async throws -> Request.Response {
        let client = HTTPAPIClient(url: baseURL, session: session)
        return try await sendTesting(request: request, client: client, send)
    }

    func sendTesting<Request: Postie.Request>(
        request: Request, client: HTTPAPIClient,
        _ send: (HTTPAPIClient, Request) async throws -> Request.Response
    ) async throws -> Request.Response {
        return try await send(client, request)
    }
}

extension XCTest {
    func XCTAssertThrowsError<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}

// swiftlint:enable nesting
