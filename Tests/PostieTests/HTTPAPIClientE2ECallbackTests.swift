import Postie
import PostieMock
import XCTest

class HTTPAPIClientE2ECallbackTests: XCTestCase {
    let baseURL = URL(string: "https://local.test")!

    func testSending_queryItems_shouldBeInRequestURI() {
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
        let stubSession = URLSessionCallbackStub(response: stubResponse) { request in
            requestedURL = request.url
        }

        // Send request
        var request = Request(value: 321)
        request.name = "This custom name"
        request.optionalGivenValue = true
        _ = sendTesting(request: request, session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }

        // Assert request URL
        XCTAssertEqual(requestedURL, URL(
            string: "?custom_name=This%20custom%20name&value=321&optionalGivenValue=true", relativeTo: baseURL
        )!.absoluteURL)
    }

    func testSending_requestHeader_shouldBeInRequestHeaders() {
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
        let stubSession = URLSessionCallbackStub(response: stubResponse) { request in
            requestHeaders = request.allHTTPHeaderFields
        }

        // Send request
        var request = Request(value: 321)
        request.name = "this custom name"
        request.optionalGivenValue = true
        _ = sendTesting(request: request, session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }

        // Assert request URL
        XCTAssertEqual(requestHeaders, [
            "custom_name": "this custom name",
            "value": "321",
            "optionalGivenValue": "true"
        ])
    }

    func testSending_requestBody_shouldBeInRequest() {
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
        let stubSession = URLSessionCallbackStub(response: stubResponse) { request in
            requestBody = request.httpBody
        }

        // Send request
        let request = Request(body: .init(value: 321))
        _ = sendTesting(request: request, session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }

        // Assert request URL
        XCTAssertEqual(requestBody, Data("{\"value\":321}".utf8))
    }

    func testSending_PlainResponse_shouldDecodeResponse() {
        struct Request: Postie.Request {
            struct Response: Decodable {
                @ResponseStatusCode var statusCode
                @ResponseBody<PlainDecodable> var body
            }
        }

        // Prepare response stub
        let stubResponse: (data: Data, response: URLResponse) = (
            data: Data(
                """
                this is random unformatted plain text
                """.utf8),
            response: HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        let stubSession = URLSessionCallbackStub(response: stubResponse)

        // Send request
        let (receivedResponse, receivedError) = sendTesting(request: Request(), session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }

        // Assert response
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedResponse)
        guard let response = receivedResponse else {
            return
        }
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.body, "this is random unformatted plain text")
    }

    func testSending_JSONResponse_shouldDecodeResponse() {
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
            data: Data(
                """
                {
                    "value": "response value"
                }
                """.utf8),
            response: HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        let stubSession = URLSessionCallbackStub(response: stubResponse)

        // Send request
        let (receivedResponse, receivedError) = sendTesting(request: Request(), session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }

        // Assert response
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedResponse)
        guard let response = receivedResponse else {
            return
        }
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.value, "response value")
    }

    func testSending_JSONArrayResponse_shouldDecodeResponseItems() {
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
            data: Data(
                """
                [
                    {
                        "value": "response value1"
                    },
                    {
                        "value": "response value2"
                    }
                ]
                """.utf8),
            response: HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        let stubSession = URLSessionCallbackStub(response: stubResponse)

        // Send request
        let (receivedResponse, receivedError) = sendTesting(request: Request(), session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }

        // Assert response
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedResponse)
        guard let response = receivedResponse else {
            return
        }
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.count, 2)
        XCTAssertEqual(response.body?[0], Request.Response.BodyItem(value: "response value1"))
        XCTAssertEqual(response.body?[1], Request.Response.BodyItem(value: "response value2"))
    }

    func testSending_invalidResponse_shouldThrowError() {
        struct Request: Postie.Request {
            struct Response: JSONDecodable {
                struct Body: Decodable {}
            }
        }

        let stubResponse: (data: Data, response: URLResponse) = (
            data: Data(),
            response: URLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )
        let stubSession = URLSessionCallbackStub(response: stubResponse)
        let (receivedResponse, receivedError) = sendTesting(request: Request(), session: stubSession) { client, request, callback in
            client.send(request, callback: callback)
        }
        XCTAssertNil(receivedResponse)
        XCTAssertNotNil(receivedError)
        guard let error = receivedError else {
            return
        }
        switch error {
        case APIError.invalidResponse:
            break
        default:
            XCTFail("Received unexpected error: \(error)")
        }
    }
}

extension HTTPAPIClientE2ECallbackTests {
    func sendTesting<Request: Postie.Request>(
        request: Request,
        session: URLSessionProvider,
        _ send: (HTTPAPIClient, Request, @escaping (Result<Request.Response, Error>) -> Void) -> Void
    ) -> (response: Request.Response?, error: Error?) {
        let client = HTTPAPIClient(url: baseURL, session: session)
        return sendTesting(request: request, client: client, send)
    }

    func sendTesting<Request: Postie.Request>(
        request: Request,
        client: HTTPAPIClient,
        _ send: (HTTPAPIClient, Request, @escaping (Result<Request.Response, Error>) -> Void) -> Void
    ) -> (response: Request.Response?, error: Error?) {
        // expectation to be fulfilled when we've received all expected values
        let resultExpectation = expectation(description: "all values received")
        var receivedResponse: Request.Response?
        var receivedError: Error?

        // subscribe to the batterySubject to run the test)
        send(client, request) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            case let .success(response):
                receivedResponse = response
            }
            resultExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        return (receivedResponse, receivedError)
    }
}
