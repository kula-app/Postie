/// Represents the format of API data.
///
/// The `APIDataFormat` enum defines the format of data used in API requests and responses.
/// It provides different cases for various data formats, such as plain text, JSON, form URL encoded, and XML.
///
/// Example usage:
/// ```
/// let format: APIDataFormat = .json
/// ```
public enum APIDataFormat {
    /// Plain text format.
    ///
    /// This case represents the plain text format for API data.
    case plain

    /// JSON format.
    ///
    /// This case represents the JSON format for API data.
    case json

    /// Form URL encoded format.
    ///
    /// This case represents the form URL encoded format for API data.
    case formURLEncoded

    /// XML format.
    ///
    /// This case represents the XML format for API data.
    case xml
}
