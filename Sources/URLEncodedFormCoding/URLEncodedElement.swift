public enum URLEncodedElement {

    case text(String)
    case list([String])

    var string: String? {
        switch self {
        case .text(let value):
            return value
        default:
            return nil
        }
    }
}
