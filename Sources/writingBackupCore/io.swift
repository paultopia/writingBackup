import Foundation

public func combineFiles(from files: [String]) throws -> String {
    let strings = try files.map { try String(contentsOfFile: $0) }
    return strings.joined(separator: "\n\n")
}

public func makeTempFile(with inString: String) -> String {
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
