.PHONY: format build test test-with-coverage	

format: format-swift-format format-swiftlint

format-swift-format:
	swift format --configuration .swift-format --in-place --recursive Sources Tests

format-swiftlint:
	swiftlint --fix --config .swiftlint.yml Sources Tests

build:
	swift build

test:
	swift test

test-with-coverage:
	swift test --enable-code-coverage

lint: lint-swift-format lint-swiftlint

lint-swift-format:
	swift format lint --configuration .swift-format --strict --recursive Sources Tests

lint-swiftlint:
	swiftlint lint --config .swiftlint.yml Sources Tests
