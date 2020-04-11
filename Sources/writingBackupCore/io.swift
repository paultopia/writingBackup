import Foundation

func readFile(from filename: String) throws -> String {
    do {
        return try String(contentsOfFile: filename)
    } catch {
        print("Cannot read file \(filename). Aborting.")
        throw FileSystemError.fileNotReadable(file: filename)
    }
}

func combineFiles(from files: [String]) throws -> String {
    try files.map { try readFile(from: $0) }
      .joined(separator: "\n\n")
}

func makeTempFile(with inString: String) -> String {
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                    isDirectory: true)
    let temporaryFilename = ProcessInfo().globallyUniqueString
    let temporaryFileURL =
      temporaryDirectoryURL.appendingPathComponent(temporaryFilename)
    try! inString.write(to: temporaryFileURL, atomically: true, encoding: String.Encoding.utf8)
    let stringPath = temporaryFileURL.path
    print("path is: \(stringPath).")
    return stringPath
}

func cleanUp(_ tempFile: String) {
    try! FileManager.default.removeItem(atPath: tempFile)
}
