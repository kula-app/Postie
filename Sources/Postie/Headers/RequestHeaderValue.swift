public protocol RequestHeaderValue {}

extension String: RequestHeaderValue {}
extension Int: RequestHeaderValue {}
extension Bool: RequestHeaderValue {}

extension Optional: RequestHeaderValue where Wrapped: RequestHeaderValue {}
