public struct APIFullResponse<Body: APIResponse> {

    public let headers: [AnyHashable: Any]
    public let body: Body

    public func header(for key: String) -> Any? {
        headers.first(where: { entry in
            if (entry.key as? String)?.lowercased() == key.lowercased() {
                return true
            }
            if entry.key.hashValue == key.hashValue {
                return true
            }
            return false
        })?.value
    }

    public func header(type: Int.Type, for key: String) -> Int? {
        // Fetch raw header value
        guard let value = header(for: key) else {
            // Header not found is a valid case
            return nil
        }
        // If the value is already a int value, return it
        if let val = value as? Int {
            return val
        }
        // If the value is a String holding an integer, try to cast it
        if let val = value as? String {
            if val.isEmpty {
                return nil
            }
            guard let val = Int(val) else {
                // The returned value is not an integer, but also not nil -> erroneous state
                fatalError()
            }
            // Return casted value
            return val
        }
        // Header found, but unknown format
        fatalError()
    }
}
