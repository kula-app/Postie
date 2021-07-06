import XCTest
@testable import Postie

class HTTPStatusCodeTests: XCTestCase {

    func testKnownStatus_continue_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.continue.rawValue, 100)
    }

    func testKnownStatus_switchingProtocols_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.switchingProtocols.rawValue, 101)
    }

    func testKnownStatus_processing_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.processing.rawValue, 102)
    }

    func testKnownStatus_earlyHints_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.earlyHints.rawValue, 103)
    }

    func testKnownStatus_ok_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.ok.rawValue, 200)
    }

    func testKnownStatus_created_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.created.rawValue, 201)
    }

    func testKnownStatus_accepted_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.accepted.rawValue, 202)
    }

    func testKnownStatus_nonAuthoritativeInformation_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.nonAuthoritativeInformation.rawValue, 203)
    }

    func testKnownStatus_noContent_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.noContent.rawValue, 204)
    }

    func testKnownStatus_resetContent_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.resetContent.rawValue, 205)
    }

    func testKnownStatus_partialContent_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.partialContent.rawValue, 206)
    }

    func testKnownStatus_multiStatus_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.multiStatus.rawValue, 207)
    }

    func testKnownStatus_alreadyReported_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.alreadyReported.rawValue, 208)
    }

    func testKnownStatus_IMused_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.IMused.rawValue, 226)
    }

    func testKnownStatus_multipleChoices_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.multipleChoices.rawValue, 300)
    }

    func testKnownStatus_movedPermanently_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.movedPermanently.rawValue, 301)
    }

    func testKnownStatus_found_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.found.rawValue, 302)
    }

    func testKnownStatus_seeOther_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.seeOther.rawValue, 303)
    }

    func testKnownStatus_notModified_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.notModified.rawValue, 304)
    }

    func testKnownStatus_useProxy_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.useProxy.rawValue, 305)
    }

    func testKnownStatus_switchProxy_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.switchProxy.rawValue, 306)
    }

    func testKnownStatus_temporaryRedirect_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.temporaryRedirect.rawValue, 307)
    }

    func testKnownStatus_permanentRedirect_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.permanentRedirect.rawValue, 308)
    }

    func testKnownStatus_badRequest_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.badRequest.rawValue, 400)
    }

    func testKnownStatus_unauthorized_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.unauthorized.rawValue, 401)
    }

    func testKnownStatus_paymentRequired_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.paymentRequired.rawValue, 402)
    }

    func testKnownStatus_forbidden_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.forbidden.rawValue, 403)
    }

    func testKnownStatus_notFound_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.notFound.rawValue, 404)
    }

    func testKnownStatus_methodNotAllowed_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.methodNotAllowed.rawValue, 405)
    }

    func testKnownStatus_notAcceptable_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.notAcceptable.rawValue, 406)
    }

    func testKnownStatus_proxyAuthenticationRequired_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.proxyAuthenticationRequired.rawValue, 407)
    }

    func testKnownStatus_requestTimeout_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.requestTimeout.rawValue, 408)
    }

    func testKnownStatus_conflict_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.conflict.rawValue, 409)
    }

    func testKnownStatus_gone_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.gone.rawValue, 410)
    }

    func testKnownStatus_lengthRequired_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.lengthRequired.rawValue, 411)
    }

    func testKnownStatus_preconditionFailed_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.preconditionFailed.rawValue, 412)
    }

    func testKnownStatus_payloadTooLarge_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.payloadTooLarge.rawValue, 413)
    }

    func testKnownStatus_uriTooLong_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.uriTooLong.rawValue, 414)
    }

    func testKnownStatus_unsupportedMediaType_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.unsupportedMediaType.rawValue, 415)
    }

    func testKnownStatus_rangeNotSatisfiable_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.rangeNotSatisfiable.rawValue, 416)
    }

    func testKnownStatus_expectationFailed_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.expectationFailed.rawValue, 417)
    }

    func testKnownStatus_imATeapot_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.imATeapot.rawValue, 418)
    }

    func testKnownStatus_misdirectedRequest_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.misdirectedRequest.rawValue, 421)
    }

    func testKnownStatus_unprocessableEntity_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.unprocessableEntity.rawValue, 422)
    }

    func testKnownStatus_locked_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.locked.rawValue, 423)
    }

    func testKnownStatus_failedDependency_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.failedDependency.rawValue, 424)
    }

    func testKnownStatus_tooEarly_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.tooEarly.rawValue, 425)
    }

    func testKnownStatus_upgradeRequired_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.upgradeRequired.rawValue, 426)
    }

    func testKnownStatus_preconditionRequired_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.preconditionRequired.rawValue, 428)
    }

    func testKnownStatus_tooManyRequests_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.tooManyRequests.rawValue, 429)
    }

    func testKnownStatus_requestHeaderFieldsTooLarge_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.requestHeaderFieldsTooLarge.rawValue, 431)
    }

    func testKnownStatus_unavailableForLegalReasons_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.unavailableForLegalReasons.rawValue, 451)
    }

    func testKnownStatus_internalServerError_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.internalServerError.rawValue, 500)
    }

    func testKnownStatus_notImplemented_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.notImplemented.rawValue, 501)
    }

    func testKnownStatus_badGateway_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.badGateway.rawValue, 502)
    }

    func testKnownStatus_serviceUnavailable_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.serviceUnavailable.rawValue, 503)
    }

    func testKnownStatus_gatewayTimeout_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.gatewayTimeout.rawValue, 504)
    }

    func testKnownStatus_httpVersionNotSupported_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.httpVersionNotSupported.rawValue, 505)
    }

    func testKnownStatus_variantAlsoNegotiates_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.variantAlsoNegotiates.rawValue, 506)
    }

    func testKnownStatus_insufficientStorage_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.insufficientStorage.rawValue, 507)
    }

    func testKnownStatus_loopDetected_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.loopDetected.rawValue, 508)
    }

    func testKnownStatus_notExtended_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.notExtended.rawValue, 510)
    }

    func testKnownStatus_networkAuthenticationRequired_shouldHaveCorrectRawValue() {
        XCTAssertEqual(HTTPStatusCode.networkAuthenticationRequired.rawValue, 511)
    }

    func testLessThanComparable_smallerRawValue_shouldBeTrue() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.internalServerError
        XCTAssertTrue(lhs < rhs)
    }

    func testLessThanComparable_equalRawValue_shouldBeFalse() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.ok
        XCTAssertFalse(lhs < rhs)
    }

    func testLessThanComparable_greaterRawValue_shouldBeFalse() {
        let lhs = HTTPStatusCode.internalServerError
        let rhs = HTTPStatusCode.ok
        XCTAssertFalse(lhs <= rhs)
    }

    func testLessOrEqualThanComparable_smallerRawValue_shouldBeTrue() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.internalServerError
        XCTAssertTrue(lhs <= rhs)
    }

    func testLessOrEqualThanComparable_equalRawValue_shouldBeTrue() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.ok
        XCTAssertTrue(lhs <= rhs)
    }

    func testLessOrEqualThanComparable_greaterRawValue_shouldBeFalse() {
        let lhs = HTTPStatusCode.internalServerError
        let rhs = HTTPStatusCode.ok
        XCTAssertFalse(lhs <= rhs)
    }

    func testGreaterThanComparable_smallerRawValue_shouldBeFalse() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.internalServerError
        XCTAssertFalse(lhs > rhs)
    }

    func testGreaterThanComparable_equalRawValue_shouldBeFalse() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.ok
        XCTAssertFalse(lhs > rhs)
    }

    func testGreaterThanComparable_greaterRawValue_shouldBeTrue() {
        let lhs = HTTPStatusCode.internalServerError
        let rhs = HTTPStatusCode.ok
        XCTAssertTrue(lhs > rhs)
    }

    func testGreaterOrEqualThanComparable_smallerRawValue_shouldBeFalse() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.internalServerError
        XCTAssertFalse(lhs >= rhs)
    }

    func testGreaterOrEqualThanComparable_equalRawValue_shouldBeTrue() {
        let lhs = HTTPStatusCode.ok
        let rhs = HTTPStatusCode.ok
        XCTAssertTrue(lhs >= rhs)
    }

    func testGreaterOrEqualThanComparable_greaterRawValue_shouldBeTrue() {
        let lhs = HTTPStatusCode.internalServerError
        let rhs = HTTPStatusCode.ok
        XCTAssertTrue(lhs >= rhs)
    }

    func testRangeCheck_validStatusAndContainedInRange_shouldBeTrue() {
        let range = HTTPStatusCode.ok..<HTTPStatusCode.badRequest
        XCTAssertTrue(range ~= 201)
    }

    func testRangeCheck_validStatusAndNotInRange_shouldBeFalse() {
        let range = HTTPStatusCode.ok..<HTTPStatusCode.badRequest
        XCTAssertFalse(range ~= 500)
    }

    func testRangeCheck_invalidStatus_shouldBeFalse() {
        let range = HTTPStatusCode.ok..<HTTPStatusCode.badRequest
        XCTAssertFalse(range ~= 1212)
    }
}
