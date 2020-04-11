import XCTest
import class Foundation.Bundle
@testable import writingBackupCore

let outputShouldBe = """
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

final class writingBackupTests: XCTestCase {
    func testDirectCall() throws {
        FileManager.default.changeCurrentDirectoryPath("tests/writingBackupTests/testfiles/")
        guard let configFile = BackupConfig(from: "backup.toml") else {
            throw FileSystemError.configFileNotParseable
        }
        try configFile.convert()
        let actualOutput = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(outputShouldBe, actualOutput)
        cleanUp("output-test.md")
    }

    func testSimpleFunction() throws {
        FileManager.default.changeCurrentDirectoryPath("tests/writingBackupTests/testfiles/")
        try runBackup()
        let actualOutput = try String(contentsOfFile: "output-test.md")
        XCTAssertEqual(outputShouldBe, actualOutput)
        cleanUp("output-test.md")
    }


    static var allTests = [
      ("testDirectCall", testDirectCall),
      ("testSimpleFunction", testSimpleFunction)
    ]
}
