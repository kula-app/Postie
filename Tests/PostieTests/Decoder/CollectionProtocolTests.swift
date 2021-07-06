import XCTest
@testable import Postie

class CollectionProtocolTests: XCTestCase {

    func testGetElementType_Set_shouldReturnElementType() {
        let erasedType: Any = type(of: Array<Int>())
        XCTAssertTrue(erasedType is CollectionProtocol.Type)
        XCTAssertTrue(Array<Int>.getElementType() is Int.Type)
    }

    func testGetElementType_Array_shouldReturnElementType() {
        let erasedType: Any = type(of: Set<Int>())
        XCTAssertTrue(erasedType is CollectionProtocol.Type)
        XCTAssertTrue(Set<Int>.getElementType() is Int.Type)
    }
}
