import PerfectLib
import Toml

let config = try! Toml(contentsOfFile: "config.toml")

let inputFile = config.string("input-file")!

public func PanDocConvert(sourceFile: String, resultFile: String, bibFile: String) throws {
    let proc = try SysProcess("pandoc",
                              args: [sourceFile,
                                     "-f", "markdown",
                                     "--filter", "pandoc-citeproc",
                                     "-t", "markdown-raw_html-citations-native_divs-native_spans",
                                     "--bibliography", bibFile,
                                     "-o", resultFile],
                              env: [("PATH", "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")])
    let res = try proc.wait(hang: true)
    if res != 0 {
        let s = try proc.stderr?.readString() ?? "Unknown Error"
        throw PerfectError.systemError(Int32(res), s)
    }
}

try PanDocConvert (
  sourceFile: inputFile,
  resultFile: "./output_test.md",
  bibFile: "pgtest.json")

print("Success!")
