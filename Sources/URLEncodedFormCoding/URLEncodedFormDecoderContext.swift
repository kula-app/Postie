class URLEncodedFormDataContext {

    var fields: [String: URLEncodedElement] = [:]

    func set(to element: URLEncodedElement, at path: [CodingKey]) {
        let key = path.map(\.stringValue).joined(separator: ".")
        fields[key] = element
    }
}
