import XCTest
@testable import Postie

class ResponseStatusCodeTests: XCTestCase {

    private struct Foo {
        @ResponseStatusCode var bar
    }

    func testPropertyWrapper_shouldHoldIntegerValue() {
        var foo = Foo()
        foo.bar = 123
        XCTAssertEqual(foo.bar, 123)
    }

    func testPropertyWrapper_shouldConformToDecodable() {
        let foo = Foo()
        let erasedType: Any = type(of: foo.bar)
        XCTAssertTrue(erasedType is Decodable.Type)
    }

    func testStatusCode_validStatusCode_shouldReturnEnum() {
        var foo = Foo()
        foo.bar = 200
        XCTAssertEqual(foo.$bar, HTTPStatusCode.ok)
    }

    func testStatusCode_invalidStatusCode_shouldReturnNil() {
        var foo = Foo()
        foo.bar = 999
        XCTAssertNil(foo.$bar)
    }
}
