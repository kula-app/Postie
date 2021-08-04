![Postie](Resources/header.jpg)

# Postie - The Next-Level HTTP API Client using Combine

<div align="center">
	<a href="https://github.com/philprime/Postie/actions">
		<img src="https://github.com/philprime/Postie/workflows/Build,%20Lint%20&%20Test/badge.svg" alt="GitHub Actions">
	</a>
	<a href="https://philprime.github.io/Postie/">
		<img src="https://raw.githubusercontent.com/philprime/Postie/gh-pages/badge.svg"/>
	</a>
	<a href="https://codecov.io/gh/kula-app/Postie">
		<img src="https://codecov.io/gh/philprime/Postie/branch/main/graph/badge.svg" alt="codecov">
	</a>
</div>

<p align="center">
    <sub>Created and maintained by <a href="https://kula.app">kula.app</a> and all the amazing <a href="https://github.com/kula-app/Postie/graphs/contributors">contributors</a>.</sub>
</p>

Postie is a pure Swift library for building URLRequests using property wrappers.

## Example

Checkout this full example starting at defining the request and the expected response, up to creating a client and sending it to the remote endpoint.

```swift
import Foundation
import Postie

// Request contains body data encoded as a JSON
struct MyRequest: JSONRequest {

    // The request body is strongly typed defined
    struct RequestBody: Encodable {
        var someNumberValue: Int
    }

    // Define the response directly inside the request, so every
    // Request-Response are isolated.
    // Also directly define, that the response body shall be decoded
    // from Form-URL-Encoding
    struct Response: FormURLEncodedDecodable {

        // The expected response body structure
        struct Body: Decodable {
            var someNumberValue: Int
        }

        // The expected response body structure, in case we did something wrong
        struct ErrorBody: Decodable {
            var message: String
        }

        // Property wrappers define the purpose
        @ResponseBody<Body> var body
        @ResponseErrorBody<ErrorBody> var errorBody

        // Access specific response headers
        @ResponseHeader<DefaultStrategy> var contentType: String

        // Status codes also have convenience utilities
        @ResponseStatusCode var statusCode
    }

    // This property holds the data which will be encoded
    var body: RequestBody

    // Location of our resource with template string
    @RequestPath var path = "/profile/{user_id}"

    // Parameter to replace in the template string
    @RequestPathParameter(name: "userId") var userId: String

    // HTTP method that shall be used
    @RequestHTTPMethod var method = .post

    // Set request headers using the property naming
    @RequestHeader var authorization: String?
}

// Create a request
var request = MyRequest(body: MyRequest.RequestBody(someNumberValue: 42),
                        userId: "my-user-id")
request.authorization = "Bearer my-oauth-token"

// Create a client
let client = HTTPAPIClient(url: URL(string: "https://example.org")!)

// Send the request
client.send(request)
    .sink { result in
        switch result {
        case .failure(let error):
            print("Oh no something went wrong :(")
            print(error)
        case .finished:
            print("Everything worked fine :)")
        }
    } receiveValue: { response in
        // The single response object contains all the interesting data
        print(response.statusCode)
        print(response.body)
        print(response.errorBody)
        print(response.contentType)
    }
```

## Core Concept

The networking layer of `Foundation` (and with `Combine`) is already quite advanced. 
Using `URLRequest` you can set many different configuration values, e.g. the HTTP Method or Headers.

Unfortunately you still need to manually serialize your payload into `Foundation.Data` and set it as the request body.
Additionally you also have to set `Content-Type` header, or otherwise the remote won't be able to understand the content.

Also the response needs to be decoded, and even if a few decoders are included, e.g. `JSONDecoder`, reading and parsing the `URLResponse` is not intuitive.

Even worse when the response structure differs in case of an error, e.g. instead of

```json
{ 
    "some": "data"
}
```

an error object is returned:

```json
{
    "error":  {
        "message": "Something went wrong!"
    }
}
```

This would require to create combined types such as this one:

```swift
struct Response: Decodable {
    struct ErrorResponse: Decodable {
        var message: String
    }

    var some: String?
    var error: ErrorResponse?
}
```

and you would have to use `nil`-checking (probably in combination with the HTTP Status Code) to see which data is present.

Postie simplifies these use cases. The main idea is defining slim `struct` types to build the requests, and serialize the associated responses.
Configuration of the request is done using property wrappers, e.g. `@QueryItem`.

## Usage

### Defining the request

Postie includes a couple of types to build your requests. As a first step, create your `Request` type, with an associated `Response`:

```swift
import Postie

struct FooRequest: Request  {
    typealias Response = EmptyResponse
}
```

The default `Request` type is used for URL requests without any body data.
If you want to include payload data, use one of the following ones:

- `PlainRequest`
- `JSONRequest`
- `FormURLEncodedRequest`

All of these expect a `body` instance variable. 
For `JSONRequest` and `FormURLEncodedRequest` the type of `body` is generic but needs to implement the `Encodable` protocol.

**Example:**

```swift
struct Foo: JSONRequest {

    struct Body: Encodable {}
    typealias Response = EmptyResponse

    var body: Body
    
}

struct Bar: FormURLEncodedRequest {

    struct Body: Encodable {}
    typealias Response = EmptyResponse

    var body: Body
    
}
```

For the `PlainRequest` the body expects a plain `String` content. Optionally you can also overwrite the `encoding` variable with a custom encoding (default is `utf8`).

**Example:**

```swift
struct Foo: PlainRequest {

    typealias Response = EmptyResponse

    var body: String
    var encoding: String.Encoding = .utf16 // default: .utf8
    
}
```

#### Setting the request HTTP Method

The default HTTP method is `GET`, but it can be overwritten by adding an instance property with the property wrapper `@RequestHTTPMethod`:

**Example:**

```swift
struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestHTTPMethod var method

}

// Usage
var request = Request()
request.method = .post
```

**Note:**

As the property name is ignored, it is possible to have multiple properties with this property wrapper, but only the *last* one will be used.

#### Setting the request URL path

The default path `/`, but it can be overwritten by adding an instance property with the property wrapper `@RequestPath`:

**Example:**

```swift
struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestPath var path

}

// Usage
let request = Request(path: "/some-detail-path")
```

Additionally the request path can contain variables using the mustache syntax, e.g. `/path/with/{variable_name}/inside`.

To set the variable value, add a new instance property using the `@RequestPathParameter` property wrapper. 
By default the encoder uses the variable name for encoding, but you can also define a custom name:

```swift
struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestPath var path = "/app/{id}/contacts/{cid}"
    @RequestPathParameter var id: Int
    @RequestPathParameter(name: "cid") var contactId: String

}

// Usage
var request = Request(id: 123)
request.contactId = "ABC456"

// Result: 
https://postie.local/app/123/contacts/ABC456
```

**Note:**

As the property name is ignored, it is possible to have multiple properties with this property wrapper, but only the *last* one will be used.
Also you need to require a leading forward slash (`/`) in the path.

#### Adding query items to the URL

Multiple query items can be added by adding them as properties using the property wrapper `@QueryItem`.

**Example:**

```swift
struct Request: Encodable {

    typealias Response = EmptyResponse

    @QueryItem
    var text: String

    @QueryItem(name: "other_text")
    var anotherQuery: String

    @QueryItem
    var optionalText: String?

}

// Usage
var request = Request(text: "foo")
request.anotherQuery = "bar"

// Result query in URL:
?text=foo&other_text=bar
```

If no custom name is set, the variable name is used. If the query item is optional, and not set (therefore `nil`), it won't be added to the list.

Supported query value types can be found in [`QueryItemValue.swift`](https://github.com/philprime/Postie/blob/main/Sources/Postie/Query/QueryItemValue.swift).

**Note:**

When using an `Array` as the query item type, every value in the array is appended using the same `name`. 
The remote server is then responsible to collect all query items with the same name and merge them into an array.

Example: `[1, 2, 3]` with name `values` becomes `?values=1&values=2&values=3`

As multiple query items can use the same custom name, they will all be appended to the query. 
This does not apply to synthesized names, as a Swift type can not have more than one property with the exact same name.

#### Adding Headers to the request

Multiple headers can be set by adding them as properties using the property wrapper `@RequestHeader`.

**Example:**

```swift
struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestHeader
    var text: String

    @RequestHeader(name: "other_text")
    var anotherQuery: String

    @RequestHeader
    var optionalText: String?

}

// Usage
var request = Request(text: "foo")
request.anotherQuery = "bar"

// Result query in URL:
?text=foo&other_text=bar
```

If no custom name is set, the variable name is used. If the header is optional, and not set (therefore `nil`), it won't be added to the list.

Supported header values types can be found in [`RequestHeaderValue.swift`](https://github.com/philprime/Postie/blob/main/Sources/Postie/Headers/RequestHeaderValue.swift).

**Note:**

As multiple query items can use the same custom name, the *last* one will be used. 
This does not apply to synthesized names, as a Swift type can not have more than one property with the exact same name.

### Defining the response

Every struct implementing `Request` expects to have an associated `Response` type implementing the `Decodable` protocol. 
In the examples above the `EmptyResponse` convenience type (which is an empty, decodable type) has been used.

The response structure will be populated with data from either the response body data or metadata.

#### Parsing the response body

To parse the response data into a `Decodable` type, add a property with the property wrapper `@ResponseBody<BodyType>` where `BodyType` is the response body type.

**Example:**

```swift
struct Request: Postie.Request {
    struct Response: Decodable {
        struct Body: Decodable {
            var value: String
        }

        @ResponseBody<Body> var body
    }
}
```

To indicate the decoding system which response data format should be expected, conform your response type to one of the following protocols:

- `PlainDecodable`
- `JSONDecodable`
- `FormURLEncodedDecodable`

For `JSONDecodable` and `FormURLEncodedDecodable` the type of `body` is generic but needs to implement the `Decodable` protocol.

**Example:**

```swift
struct Request: Postie.Request {
    struct Response: Decodable {
        struct Body: JSONDecodable {
            var value: String
        }

        @ResponseBody<Body> var body
    }
}

struct Request: Postie.Request {
    struct Response: Decodable {
        struct Body: FormURLEncodedDecodable {
            var value: String
        }

        @ResponseBody<Body> var body
    }
}
```

For the type `PlainDecodable`, use it directly, as it is an alias for `String`.

**Example:**

```swift
struct Request: Postie.Request {
    struct Response: Decodable {
        @ResponseBody<PlainDecodable> var body
    }
}
```

#### Response body on error

As mentioned in [Core Concept](#core-concept) Postie allows defining a body response type when receiving an invalid status code (>=400).

It's usage is exactly the same as with `@ResponseBody`, but instead you need to use the property wrapper `@ResponseErrorBody`.
Either the `@ResponseBody` or the `@ResponseErrorBody` is set, never both at the same time. 

The error response body gets set if the response status code is neither a 2XX nor a 3XX status code.

**Example:**

```swift
struct Request: Postie.Request {
    struct Response: Decodable {
        struct ErrorBody: JSONDecodable {
            var message: String
        }
        @ResponseErrorBody<ErrorBody> var errorBody
    }
}
```

#### Response headers

Use the property wrapper `@ResponseHeader<Strategy>` inside the response type. 

In the moment, the following decoding strategies are implemented:

- `DefaultStategy`

Converts the property name into camel-case format (e.g. `Content-Type` becomes `contentType`) and compares case-insensitive (e.g. `Authorization` equals `authorization`)
This strategy expects the response header to be set, otherwise an error will be thrown.

Response from URL requests are always of type `String` and no casting will be performed. Therefore the only valid property type is `String`.

- `DefaultOptionalStategy`

Same as `DefaultStrategy` but won't fail if the header can not be found.

**Example:**

```swift
struct Response: Decodable {

    @ResponseHeader<DefaultStrategy>
    var authorization: String

    @ResponseHeader<DefaultStrategy>
    var contentType: String

    @ResponseHeader<DefaultStrategyOptional>
    var optionalValue: String?

}
```

#### Response Status

The default HTTP method is `GET`, but it can be overwritten by adding an instance property with the property wrapper `@RequestHTTPMethod`:

**Example:**

```swift
struct Response: Decodable {

    @ResponseStatusCode var statusCode

}
```

**Note:**

Multiple properties can be declared with this property wrapper. All of them will have the value set.

### HTTP API Client

The easiest way of sending Postie requests, is using the `HTTPAPIClient` which takes care of encoding requests, and decoding responses.

All it takes to create a client, is the URL which is used as a base for all requests. Afterwards you can just send the requests, using the Combine publishers.

Additionally the `HTTPAPIClient` provides the option of setting a `session` provider, which encapsulates the default `URLSession` by a protocol.
This allows to create networking clients which can be mocked (perfect for unit testing).

**Example:**

```swift
let url: URL = ...
let client = HTTPAPIClient(baseURL: url)

// ... create request ...

client.send(request)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            // handle error
            break
        case .finished:
            break
        }
    }, receiveValue: { response in
        // process response
        print(response)
    })
    .store(in: &cancellables)
//
```

### Encoding & Decoding

The `RequestEncoder` is responsible to turn an encodable `Request` into an `URLRequest`. It requires an URL in the initializer, as Postie requests are relative requests.

**Example:**

```swift
// A request as explained above
let request: Request = ...

// Create a request encoder
let url = URL(string: "http://techprimate.com")
let encoder = RequestEncoder(baseURL: url)

// Encode request
let urlRequest: URLRequest
do {
    let urlRequest = try encoder.encode(request)
    // continue with url request
    ...
} catch {
    // Handle error
    ...
}
```

As its contrarity component, the `RequestDecoder` is responsible to turn a tuple of `(data: Data, response: HTTPURLResponse)` into a given type `Response`.

**Example:**

```swift
// Data received from the URL session task
let response: HTTPURLResponse = ...
let data: Data = ...

// Create decoder
let decoder = ResponseDecoder()
do {
    let decoded = try decoder.decode(Response.self, from: (data, response))) 
    // continue with decoded response
    ...
} catch{
    // Handle error
    ...
}
```

#### Combine Support

`RequestEncoder` conforms to `TopLevelEncoder` and `RequestDecoder` conforms to `TopLevelDecoder`.
This means both encoders can be used in a Combine pipeline.

**Example:**

```swift
let request = Request()
let session = URLSession.shared

let url = URL(string: "https://techprimate.com")!
let encodedRequest = try RequestEncoder(baseURL: url).encode(request)

// Send request using the given URL session provider
return session
    .dataTaskPublisher(for: encodedRequest)
    .tryMap { (data: Data, response: URLResponse) in
        guard let response = response as? HTTPURLResponse else {
            fatalError("handle non HTTP url responses")
        }
        return (data: data, response: response)
    }
    .decode(type: Request.Response.self, decoder: ResponseDecoder())
    .sink(receiveCompletion: { result in
        // handle result
    }, receiveValue: { decoded in
        // do something with decoded response
    })
```

# Articles & Stories

Here is a list of relevant articles and stories regarding Postie 🥳

(Please let us know if you found more.)

- [Installing Xcode with “not enough disk space available”](https://philprime.medium.com/installing-xcode-with-not-enough-disk-space-available-b96c8f17115b) - by Philip Niedertscheider