/// Common HTTP Status Codes
///
/// Reference: [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
public enum HTTPStatusCode: UInt16 {

    // +---------------------------------------------------------------------------+
    // | 1xx informational response – the request was received, continuing process |
    // +---------------------------------------------------------------------------+

    /// The server has received the request headers and the client should proceed to send the request body (in the case of a request for which a body needs to be sent; for example, a POST request). Sending a large request body to a server after a request has been rejected for inappropriate headers would be inefficient. To have a server check the request's headers, a client must send Expect: 100-continue as a header in its initial request and receive a 100 Continue status code in response before sending the body. If the client receives an error code such as 403 (Forbidden) or 405 (Method Not Allowed) then it should not send the request's body. The response 417 Expectation Failed indicates that the request should be repeated without the Expect header as it indicates that the server does not support expectations (this is the case, for example, of HTTP/1.0 servers).[4]
    case `continue` = 100

    /// The requester has asked the server to switch protocols and the server has agreed to do so.
    case switchingProtocols = 101

    /// A WebDAV request may contain many sub-requests involving file operations, requiring a long time to complete the request. This code indicates that the server has received and is processing the request, but no response is available yet.[6] This prevents the client from timing out and assuming the request was lost.
    ///
    /// (WebDAV; RFC 2518)
    case processing = 102

    /// Used to return some response headers before final HTTP message.
    ///
    /// (RFC 8297)
    case earlyHints = 103

    // +----------------------------------------------------------------------------------+
    // | 2xx successful – the request was successfully received, understood, and accepted |
    // +----------------------------------------------------------------------------------+

    /// Standard response for successful HTTP requests. The actual response will depend on the request method used. In a GET request, the response will contain an entity corresponding to the requested resource. In a POST request, the response will contain an entity describing or containing the result of the action.[8]
    case ok = 200

    /// The request has been fulfilled, resulting in the creation of a new resource.[9]
    case created = 201

    /// The request has been accepted for processing, but the processing has not been completed. The request might or might not be eventually acted upon, and may be disallowed when processing occurs.[10]
    case accepted = 202

    /// The server is a transforming proxy (e.g. a Web accelerator) that received a 200 OK from its origin, but is returning a modified version of the origin's response.[11][12]
    case nonAuthoritativeInformation = 203

    /// The server successfully processed the request, and is not returning any content.[13]
    case noContent = 204

    /// The server successfully processed the request, asks that the requester reset its document view, and is not returning any content.[14]
    case resetContent = 205

    /// The server is delivering only part of the resource (byte serving) due to a range header sent by the client. The range header is used by HTTP clients to enable resuming of interrupted downloads, or split a download into multiple simultaneous streams.[15]
    ///
    /// (RFC 7233)
    case partialContent = 206

    /// The message body that follows is by default an XML message and can contain a number of separate response codes, depending on how many sub-requests were made.[16]
    ///
    /// (WebDAV; RFC 4918)
    case multiStatus = 207

    /// The members of a DAV binding have already been enumerated in a preceding part of the (multistatus) response, and are not being included again.
    ///
    /// (WebDAV; RFC 5842)
    case alreadyReported = 208

    /// The server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.[17]
    ///
    /// (RFC 3229)
    case IMused = 226

    // +-------------------------------------------------------------------------------------+
    // | 3xx redirection – further action needs to be taken in order to complete the request |
    // +-------------------------------------------------------------------------------------+

    /// Indicates multiple options for the resource from which the client may choose (via agent-driven content negotiation).
    ///
    /// For example, this code could be used to present multiple video format options, to list files with different filename extensions, or to suggest word-sense disambiguation.[19]
    case multipleChoices = 300

    /// This and all future requests should be directed to the given URI.[20]
    case movedPermanently = 301

    /// Tells the client to look at (browse to) another URL (Previously "Moved temporarily")
    ///
    ///  302 has been superseded by 303 and 307.
    ///  This is an example of industry practice contradicting the standard.
    ///  The HTTP/1.0 specification (RFC 1945) required the client to perform a temporary redirect (the original describing phrase was "Moved Temporarily"), but popular browsers implemented 302 with the functionality of a 303 See Other.
    ///  Therefore, HTTP/1.1 added status codes 303 and 307 to distinguish between the two behaviours.
    ///  However, some Web applications and frameworks use the 302 status code as if it were the 303.
    case found = 302

    /// The response to the request can be found under another URI using the GET method.
    ///
    /// When received in response to a POST (or PUT/DELETE), the client should presume that the server has received the data and should issue a new GET request to the given URI.[24]
    ///
    /// (since HTTP/1.1)
    case seeOther = 303

    /// Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match.
    /// In such case, there is no need to retransmit the resource since the client still has a previously-downloaded copy.[25]
    ///
    /// (RFC 7232)
    case notModified = 304

    /// The requested resource is available only through a proxy, the address for which is provided in the response.
    /// For security reasons, many HTTP clients (such as Mozilla Firefox and Internet Explorer) do not obey this status code.[26]
    ///
    /// (since HTTP/1.1)
    case useProxy = 305

    /// No longer used. Originally meant "Subsequent requests should use the specified proxy."[27]
    case switchProxy = 306

    /// In this case, the request should be repeated with another URI; however, future requests should still use the original URI.
    ///
    /// In contrast to how 302 was historically implemented, the request method is not allowed to be changed when reissuing the original request.
    /// For example, a POST request should be repeated using another POST request.[28]
    ///
    /// (since HTTP/1.1)
    case temporaryRedirect = 307

    /// The request and all future requests should be repeated using another URI.
    ///
    /// 307 and 308 parallel the behaviors of 302 and 301, but do not allow the HTTP method to change.
    /// So, for example, submitting a form to a permanently redirected resource may continue smoothly.[29]
    ///
    /// (RFC 7538)
    case permanentRedirect = 308

    // +---------------------------------------------------------------------------+
    // | 4xx client error – the request contains bad syntax or cannot be fulfilled |
    // +---------------------------------------------------------------------------+

    /// The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing).[31]
    ///
    /// (RFC 7235)
    case badRequest = 400

    /// Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided.
    ///
    /// The response must include a WWW-Authenticate header field containing a challenge applicable to the requested resource. See Basic access authentication and Digest access authentication.
    /// 401 semantically means "unauthorised",[33] the user does not have valid authentication credentials for the target resource.
    /// Note: Some sites incorrectly issue HTTP 401 when an IP address is banned from the website (usually the website domain) and that specific address is refused permission to access a website.[citation needed]
    case Unauthorized = 401

    /// Reserved for future use. The original intention was that this code might be used as part of some form of digital cash or micropayment scheme, as proposed, for example, by GNU Taler,[34] but that has not yet happened, and this code is not widely used. Google Developers API uses this status if a particular developer has exceeded the daily limit on requests.[35] Sipgate uses this code if an account does not have sufficient funds to start a call.[36] Shopify uses this code when the store has not paid their fees and is temporarily disabled.[37] Stripe uses this code for failed payments where parameters were correct, for example blocked fraudulent payments.[38]
    case paymentRequired = 402

    /// The request contained valid data and was understood by the server, but the server is refusing action. This may be due to the user not having the necessary permissions for a resource or needing an account of some sort, or attempting a prohibited action (e.g. creating a duplicate record where only one is allowed). This code is also typically used if the request provided authentication by answering the WWW-Authenticate header field challenge, but the server did not accept that authentication. The request should not be repeated.
    case forbidden = 403

    /// The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible.
    case notFound = 404

    /// A request method is not supported for the requested resource; for example, a GET request on a form that requires data to be presented via POST, or a PUT request on a read-only resource.
    case methodNotAllowed = 405

    /// The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request.[39] See Content negotiation.
    case notAcceptable = 406

    /// The client must first authenticate itself with the proxy.[40]
    ///
    /// (RFC 7235)
    case proxyAuthenticationRequired = 407

    /// The server timed out waiting for the request.
    ///
    /// According to HTTP specifications:
    /// "The client did not produce a request within the time that the server was prepared to wait. The client MAY repeat the request without modifications at any later time."
    case requestTimeout = 408

    /// Indicates that the request could not be processed because of conflict in the current state of the resource, such as an edit conflict between multiple simultaneous updates.
    case conflict = 409

    /// Indicates that the resource requested is no longer available and will not be available again. This should be used when a resource has been intentionally removed and the resource should be purged. Upon receiving a 410 status code, the client should not request the resource in the future. Clients such as search engines should remove the resource from their indices.[42] Most use cases do not require clients and search engines to purge the resource, and a "404 Not Found" may be used instead.
    case gone = 410

    /// The request did not specify the length of its content, which is required by the requested resource.[43]
    case lengthRequired = 411

    /// The server does not meet one of the preconditions that the requester put on the request header fields.[44]
    ///
    /// (RFC 7232)
    case preconditionFailed = 412

    /// The request is larger than the server is willing or able to process. Previously called "Request Entity Too Large".[45]
    ///
    /// (RFC 7231)
    case payloadTooLarge = 413

    /// The URI provided was too long for the server to process.
    ///
    /// Often the result of too much data being encoded as a query-string of a GET request, in which case it should be converted to a POST request.[46]
    /// Called "Request-URI Too Long" previously.[47]
    ///
    /// (RFC 7231)
    case uriTooLong = 414

    /// The request entity has a media type which the server or resource does not support. For example, the client uploads an image as image/svg+xml, but the server requires that images use a different format.[48]
    ///
    /// (RFC 7231)
    case unsupportedMediaType = 415

    /// The client has asked for a portion of the file (byte serving), but the server cannot supply that portion. For example, if the client asked for a part of the file that lies beyond the end of the file.[49] Called "Requested Range Not Satisfiable" previously.[50]
    ///
    /// (RFC 7233)
    case rangeNotSatisfiable = 416

    /// The server cannot meet the requirements of the Expect request-header field.[51]
    case expectationFailed = 417

    /// This code was defined in 1998 as one of the traditional IETF April Fools' jokes, in RFC 2324, Hyper Text Coffee Pot Control Protocol, and is not expected to be implemented by actual HTTP servers.
    ///
    /// The RFC specifies this code should be returned by teapots requested to brew coffee.[52]
    /// This HTTP status is used as an Easter egg in some websites, such as Google.com's I'm a teapot easter egg.[53][54]
    ///
    /// (RFC 2324, RFC 7168)
    case imATeapot = 418

    /// The request was directed at a server that is not able to produce a response[55] (for example because of connection reuse).[56]
    ///
    /// (RFC 7540)
    case misdirectedRequest = 421

    /// The request was well-formed but was unable to be followed due to semantic errors.[16]
    ///
    /// (WebDAV; RFC 4918)
    case unprocessableEntity = 422

    /// The resource that is being accessed is locked.[16]
    ///
    /// (WebDAV; RFC 4918)
    case locked = 423

    /// The request failed because it depended on another request and that request failed (e.g., a PROPPATCH).[16]
    ///
    /// (WebDAV; RFC 4918)
    case failedDependency = 424

    /// Indicates that the server is unwilling to risk processing a request that might be replayed.
    ///
    /// (RFC 8470)
    case tooEarly = 425

    /// The client should switch to a different protocol such as TLS/1.3, given in the Upgrade header field.[57]
    case upgradeRequired = 426

    /// The origin server requires the request to be conditional.
    ///
    /// Intended to prevent the 'lost update' problem, where a client GETs a resource's state, modifies it, and PUTs it back to the server, when meanwhile a third party has modified the state on the server, leading to a conflict.[58]
    /// (RFC 6585)
    case preconditionRequired = 428

    /// The user has sent too many requests in a given amount of time. Intended for use with rate-limiting schemes.[58]
    ///
    /// (RFC 6585)
    case tooManyRequests = 429

    /// The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large.[58]
    ///
    /// (RFC 6585)
    case requestHeaderFieldsTooLarge = 431

    /// A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource.[59] The code 451 was chosen as a reference to the novel Fahrenheit 451 (see the Acknowledgements in the RFC).
    ///
    /// Notes: (RFC 7725)
    case unavailableForLegalReasons = 451

    // +----------------------------------------------------------------------------+
    // | 5xx server error – the server failed to fulfil an apparently valid request |
    // +----------------------------------------------------------------------------+

    /// A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.[62]
    case internalServerError = 500

    /// The server either does not recognize the request method, or it lacks the ability to fulfil the request. Usually this implies future availability (e.g., a new feature of a web-service API).[63]
    case notImplemented = 501

    /// The server was acting as a gateway or proxy and received an invalid response from the upstream server.[64]
    case badGateway = 502

    /// The server cannot handle the request (because it is overloaded or down for maintenance). Generally, this is a temporary state.[65]
    case serviceUnavailable = 503

    /// The server was acting as a gateway or proxy and did not receive a timely response from the upstream server.[66]
    case gatewayTimeout = 504

    /// The server does not support the HTTP protocol version used in the request.[67]
    case httpVersionNotSupported = 505

    /// Transparent content negotiation for the request results in a circular reference.[68]
    ///
    /// (RFC 2295)
    case variantAlsoNegotiates = 506

    /// The server is unable to store the representation needed to complete the request.[16]
    ///
    /// (WebDAV; RFC 4918)
    case insufficientStorage = 507

    /// The server detected an infinite loop while processing the request (sent instead of 208 Already Reported).
    ///
    /// (WebDAV; RFC 5842)
    case loopDetected = 508

    /// Further extensions to the request are required for the server to fulfil it.[69]
    ///
    /// (RFC 2774)
    case notExtended = 510

    /// The client needs to authenticate to gain network
    ///
    /// (RFC 6585)
    case networkAuthenticationRequired = 511

}

extension HTTPStatusCode: Comparable, Equatable {

    public static func < (lhs: HTTPStatusCode, rhs: HTTPStatusCode) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public static func > (lhs: HTTPStatusCode, rhs: HTTPStatusCode) -> Bool {
        lhs.rawValue > rhs.rawValue
    }

    public static func >= (lhs: HTTPStatusCode, rhs: HTTPStatusCode) -> Bool {
        lhs > rhs || lhs == rhs
    }

    public static func == (lhs: HTTPStatusCode, rhs: HTTPStatusCode) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

func ~= (range: Range<HTTPStatusCode>, value: Int) -> Bool {
    guard let status = HTTPStatusCode(rawValue: UInt16(value)) else {
        return false
    }
    return range.contains(status)
}
