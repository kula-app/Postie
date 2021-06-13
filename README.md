# Postie - Structured HTTP Client using Combine

Postie is a pure Swift library for building URLRequests using property wrappers.

## Core Concept

The networking layer of `Foundation` (and with `Combine`) is already quite advanced. 
Using `URLRequest` you can set many different configuration values, e.g. the HTTP Method or Headers.

Unfortunately you still need to manually serialize your payload into `Foundation.Data` and set it as the request body.
Additionally you also have to set `Content-Type` header, or otherwise the remote won't be able to understand the content.

Also the response needs to be decoded, and even if a few decoders are included, e.g. `JSONDecoder`, reading and parsing the `URLResponse` is not intuitive.

Even worse when the response structure differs in case of an error, e.g. instead of

```
{ 
    "some": "data"
}
```

an error object is returned:

```
{
    "error":  {
        "message": "Something went wrong!"
    }
}
```

This would require to create combined types such as this one:

```
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


```
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

```
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

```
struct Foo: PlainRequest {

    typealias Response = EmptyResponse

    var body: String
    var encoding: String.Encoding = .utf16 // default: .utf8
    
}
```

#### Setting the request HTTP Method

The default HTTP method is `GET`, but it can be overwritten by adding an instance property with the property wrapper `@RequestHTTPMethod`:

```
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

```
struct Request: Encodable {

    typealias Response = EmptyResponse

    @RequestHTTPMethod var method

}

// Usage
let request = Request(path: "/some-detail-path")
```

**Note:**

As the property name is ignored, it is possible to have multiple properties with this property wrapper, but only the *last* one will be used.
Also you need to require a leading forward slash (`/`) in the path.

#### Adding query items to the URL

Multiple query items can be added by adding them as properties using the property wrapper `@QueryItem`

```
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

Multiple headers can be set by adding them as properties using the property wrapper `@RequestHeader`

```
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

Every struct implementing `Request` expects to have an associated `Response` type. 
In the examples above the `EmptyResponse` convenience type (which is an empty, decodable type) has been used.
