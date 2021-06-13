public protocol QueryItemValue {}

extension String: QueryItemValue {}
extension Int: QueryItemValue {}
extension Bool: QueryItemValue {}
extension Optional: QueryItemValue where Wrapped: QueryItemValue {}
extension Array: QueryItemValue where Element: QueryItemValue {}
