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

let outputShouldNotBeOverwritten = "THIS FILE SHOULD NOT BE CHANGED\n\n" + outputNoCites

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

    func executeBasicTest(dir: String, correctOutput: String) throws {
        FileManager.default.changeCurrentDirectoryPath(dir)
        let outputData = try runBackup()
        let tempFile = outputData.0
        let prefix = outputData.1
        XCTAssertFalse(FileManager.default.fileExists(atPath: tempFile))
        let actualOutput = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(prefix + correctOutput, actualOutput)
        try cleanUp("output-test.md")
        XCTAssertFalse(FileManager.default.fileExists(atPath: "output-test.md"))
    }

    func testSimpleFunction() throws {
        let dir = "tests/writingBackupTests/testfiles/"
        try executeBasicTest(dir: dir, correctOutput: outputWithCites)
    }

    func testNoCites() throws {
        let dir = "tests/writingBackupTests/testfiles/nocites/"
        try executeBasicTest(dir: dir, correctOutput: outputNoCites)
    }

    func testGoodOverwrite() throws {
        // not using basic test because I don't want the file deleted.
        FileManager.default.changeCurrentDirectoryPath("tests/writingBackupTests/testfiles/file_exists_ok/")
        let outputData = try runBackup()
        let tempFile = outputData.0
        let prefix = outputData.1
        XCTAssertFalse(FileManager.default.fileExists(atPath: tempFile))
        let actualOutput = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(prefix + outputNoCites, actualOutput)
        // leaving the file there to be a good overwrite for next time; this test will false positive if run a second time less than a second letter
    }

    func testBadOverwrite() throws {
        FileManager.default.changeCurrentDirectoryPath("tests/writingBackupTests/testfiles/file_exists_bad/")
        XCTAssertThrowsError(try runBackup())
        let existingFile = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(outputShouldNotBeOverwritten, existingFile)
    }

    func testSimpleDirectory() throws {
        let dir = "tests/writingBackupTests/testfiles/directory/"
        try executeBasicTest(dir: dir, correctOutput: outputWithCites)
    }

    func testComplexDirectory() throws {
        let dir = "tests/writingBackupTests/testfiles/complex_directory/"
        let correctOutput = "this is a document without any citations." + "\n\n" + outputWithCites
        try executeBasicTest(dir: dir, correctOutput: correctOutput)
    }

    static var allTests = [
      ("testNoCites", testNoCites),
      ("testSimpleFunction", testSimpleFunction),
      ("testGoodOverwrite", testGoodOverwrite),
      ("testBadOverwrite", testBadOverwrite),
      ("testSimpleDirectory", testSimpleDirectory),
      ("testComplexDirectory", testComplexDirectory)
    ]
}
