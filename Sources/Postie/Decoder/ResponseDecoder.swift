import Combine
import Foundation

public class ResponseDecoder: TopLevelDecoder {

    public func decode<T>(_ type: T.Type, from: (data: Data, response: HTTPURLResponse, failsOnEmptyData: Bool)) throws -> T where T: Decodable {
        let decoder = ResponseDecoding(response: from.response, data: from.data, failsOnEmptyData: from.failsOnEmptyData)
        return try T(from: decoder)
    }
}
