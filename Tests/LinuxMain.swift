import XCTest

import GlideshowTests

var tests = [XCTestCaseEntry]()
tests += GlideshowTests.allTests()
XCTMain(tests)

fatalError("Running tests like this is unsupported. Run the tests again by using `swift test --enable-test-discovery`")
