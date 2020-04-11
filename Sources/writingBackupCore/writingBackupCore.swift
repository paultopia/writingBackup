import PerfectLib
import Toml
import Foundation

extension Toml {
    func readString(label key: String) throws -> String {
        guard let value = self.string(key) else {
            print("Can't read \(key) in backup.toml. It should be an array with a list of filenames.")
            throw FileSystemError.configFileMisformatted(key: key)
        }
        return value
    }

    func readArray(label key: String) throws -> [String] {  // should probably be generic but whev
        guard let values: [String] = self.array(key) else {
            print("Can't read \(key) in backup.toml. It should be a filename.")
            throw FileSystemError.configFileMisformatted(key: key)
        }
        return values
    }
}

struct BackupConfig {
    var inFiles: [String]
    var outFile: String
    var bibFile: String?

    init(from configFile: String) throws {
        if let config = try? Toml(contentsOfFile: configFile) {
            try self.inFiles = config.readArray(label: "inFiles")
            try self.outFile = config.readString(label: "outFile")
            self.bibFile = config.string("bibFile") // should just be nil if not found
        } else {
            print("Can't parse backup.toml.  Is the file correctly formatted?")
            throw FileSystemError.configFileNotParseable
        }

    }

    func convert() throws -> String {
        let combined = try combineFiles(from: self.inFiles)
        let tempFile = try makeTempFile(with: combined)
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
            let message = "Error code: \(Int32(res)), Stderr: \(s)"
            throw FileSystemError.pandocFailure(message: message)
        }
        print("successfully backed up \(self.inFiles) to \(self.outFile)!")
        try cleanUp(tempFile)
        return tempFile // returning it just for testing purposes to make sure it gets deleted.
    }
}

public func runBackup() throws -> String {
    let configFile = try BackupConfig(from: "backup.toml") 
    let tempFilePath = try configFile.convert()
    return tempFilePath // returning it just for testing purposes to make sure it gets deleted.
}
