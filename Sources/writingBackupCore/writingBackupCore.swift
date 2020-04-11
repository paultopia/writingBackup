import PerfectLib
import Toml
import Foundation

extension Toml {
    func readString(label key: String) throws -> String {
        guard let value = self.string(key) else {
            print("can't read \(key) in backup.toml")
            throw FileSystemError.configFileMisformatted(key: key)
        }
        return value
    }

    func readArray(label key: String) throws -> [String] {  // should probably be generic but whev
        guard let values: [String] = self.array(key) else {
            print("can't read \(key) in backup.toml")
            throw FileSystemError.configFileMisformatted(key: key)
        }
        return values
    }
}

public struct BackupConfig {
    public var inFiles: [String]
    public var outFile: String
    public var bibFile: String?

    public init(from configFile: String) throws {
        if let config = try? Toml(contentsOfFile: configFile) {
            try self.inFiles = config.readArray(label: "inFiles")
            try self.outFile = config.readString(label: "outFile")
            try self.bibFile = config.readString(label: "bibFile")
        } else {
            print("Can't parse backup.toml.  Is the file correctly formatted?")
            throw FileSystemError.configFileNotParseable
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
    let configFile = try BackupConfig(from: "backup.toml") 
    try configFile.convert()
}
