import XCTest

import writingBackupTests

var tests = [XCTestCaseEntry]()
tests += writingBackupTests.allTests()
XCTMain(tests)
