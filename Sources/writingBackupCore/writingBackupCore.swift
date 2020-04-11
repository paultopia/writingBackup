import PerfectLib
import Toml
import Foundation


public struct BackupConfig {
    public var inFiles: [String]
    public var outFile: String
    public var bibFile: String?

    public init?(from configFile: String) {
        if let config = try? Toml(contentsOfFile: configFile) {
            self.inFiles = config.array("inFiles")!
            self.outFile = config.string("outFile")!
            self.bibFile = config.string("bibFile")
        } else {
            print("Can't parse backup.toml.  Is the file correctly formatted?")
            return nil
        }

    }

    public func convert() throws {
        let combined = try! combineFiles(from: self.inFiles)
        let tempFile = makeTempFile(with: combined)
        var args: [String]
        let env = [("PATH", "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")]
        if let references = self.bibFile {
            args = [tempFile,
                        "-f", "markdown",
                        "--filter", "pandoc-citeproc",
                        "-t", "markdown-raw_html-citations-native_divs-native_spans",
                        "--bibliography", references,
                        "-o", NSString(string: self.outFile).expandingTildeInPath]
        }
        else {
            args = [tempFile,
                        "-f", "markdown",
                        "-o", NSString(string: self.outFile).expandingTildeInPath]
        }

        let proc = try SysProcess("pandoc",
                                  args: args,
                                  env: env)
        let res = try proc.wait(hang: true)
        if res != 0 {
            let s = try proc.stderr?.readString() ?? "Unknown Error"
            throw PerfectError.systemError(Int32(res), s)
        }
        print("successfully backed up \(self.inFiles) to \(self.outFile)!")
        cleanUp(tempFile)
    }
}

public func runBackup() throws {
    guard let configFile = BackupConfig(from: "backup.toml") else {
        print("Cannot load configuration. Giving up.")
        throw FileSystemError.configFileNotParseable
    }
    try configFile.convert()
}
