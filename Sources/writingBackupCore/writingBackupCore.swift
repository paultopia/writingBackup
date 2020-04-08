import PerfectLib
import Toml
import Foundation


public struct BackupConfig {
    public var inFiles: [String]
    public var outFile: String
    public var bibFile: String?

    public init(from configFile: String) {
        let config = try! Toml(contentsOfFile: configFile)
        self.inFiles = config.array("inFiles")!
        self.outFile = config.string("outFile")!
        self.bibFile = config.string("bibFile")
    }

    public func convert() throws {
        let combined = try! combineFiles(from: self.inFiles)
        let tempFile = makeTempFile(with: combined)
        if let references = self.bibFile {
            let args = [tempFile,
                        "-f", "markdown",
                        "--filter", "pandoc-citeproc",
                        "-t", "markdown-raw_html-citations-native_divs-native_spans",
                        "--bibliography", references,
                        "-o", NSString(string: self.outFile).expandingTildeInPath]
        }
        else {
            let args = [tempFile,
                        "-f", "markdown",
                        "-o", NSString(string: self.outFile).expandingTildeInPath]
        }
        print("successfully backed up \(self.inFiles) to \(self.outFile)!")
    }
}





public func PanDocConvert(sourceFile: String, resultFile: String, bibFile: String) throws {
    let proc = try SysProcess("pandoc",
                              args: [sourceFile,
                                     "-f", "markdown",
                                     "--filter", "pandoc-citeproc",
                                     "-t", "markdown-raw_html-citations-native_divs-native_spans",
                                     "--bibliography", bibFile,
                                     "-o", NSString(string: resultFile).expandingTildeInPath],
                              env: [("PATH", "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")])
    let res = try proc.wait(hang: true)
    if res != 0 {
        let s = try proc.stderr?.readString() ?? "Unknown Error"
        throw PerfectError.systemError(Int32(res), s)
    }
}

public func runTests() {
    print("running")
}

