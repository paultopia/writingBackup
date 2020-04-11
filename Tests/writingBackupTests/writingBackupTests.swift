import XCTest
import class Foundation.Bundle
@testable import writingBackupCore

let outputWithCites = """
this is a test (Gowder 2014) cited me.

this is a second file

::: {#refs .references}
::: {#ref-gowder_equal_2014-1}
Gowder, Paul. 2014. "Equal Law in an Unequal World." *Iowa Law Review*
99 (3): 1021--81.
<http://www.jstor.org.proxy.lib.uiowa.edu/stable/10.1086/233897#references_tab_contents>.
:::
:::

"""

let outputNoCites = """
this is a document without any citations.

this is a second file

"""


final class writingBackupTests: XCTestCase {

    static var initialPath = ""

    override class func setUp() { // get the initial path to reset at every method
        super.setUp()
        initialPath = FileManager.default.currentDirectoryPath
    }

    override func setUp() {
        super.setUp()
        FileManager.default.changeCurrentDirectoryPath(writingBackupTests.initialPath)
    }

    func testSimpleFunction() throws {
        FileManager.default.changeCurrentDirectoryPath("tests/writingBackupTests/testfiles/")
        let tempFile = try runBackup()
        XCTAssertFalse(FileManager.default.fileExists(atPath: tempFile))
        let actualOutput = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(outputWithCites, actualOutput)
        try cleanUp("output-test.md")
        XCTAssertFalse(FileManager.default.fileExists(atPath: "output-test.md"))
    }

    func testNoCites() throws {
        FileManager.default.changeCurrentDirectoryPath("tests/writingBackupTests/testfiles/nocites/")
        let tempFile = try runBackup()
        XCTAssertFalse(FileManager.default.fileExists(atPath: tempFile))
        let actualOutput = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(outputNoCites, actualOutput)
        try cleanUp("output-test.md")
        XCTAssertFalse(FileManager.default.fileExists(atPath: "output-test.md"))
    }

    static var allTests = [
      ("testNoCites", testNoCites),
      ("testSimpleFunction", testSimpleFunction)
    ]
}
