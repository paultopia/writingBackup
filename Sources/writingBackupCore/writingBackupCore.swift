import PerfectLib
import Toml

public func readConfig() -> String {
    let config = try! Toml(contentsOfFile: "config.toml")
    let inputFile = config.string("input-file")!
    return inputFile
}



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

public func runTests() {
    print("running")
}

