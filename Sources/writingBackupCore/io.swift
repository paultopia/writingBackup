import Foundation

func readFile(from filename: String) throws -> String {
    do {
        return try String(contentsOfFile: filename)
    } catch {
        print("Cannot read file \(filename). Aborting.")
        throw FileSystemError.fileNotReadable(file: filename)
    }
}

func makePath(root: String, filename: String) -> String {
    if root.hasSuffix("/") {
        return root + filename
    } else {
        return root + "/" + filename
    }
}

func combineFiles(from files: [String]) throws -> String {
    var output: [String] = []
    for pathname in files {
        if let contents = try? String(contentsOfFile: pathname) {
            output.append(contents)
        } else {
            do {
                let dircontents = try FileManager.default.contentsOfDirectory(atPath: pathname)
                  .sorted(by: <)
                  .map { makePath(root: pathname, filename: $0) }
                  .map { try readFile(from: $0) }
                output.append(contentsOf: dircontents)
            } catch {
                throw FileSystemError.fileNotReadable(file: pathname)
            }
        }
    }
    return output
      .joined(separator: "\n\n")
}

func makeTempFile(with inString: String) throws -> String {
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                    isDirectory: true)
    let temporaryFilename = ProcessInfo().globallyUniqueString
    let temporaryFileURL =
      temporaryDirectoryURL.appendingPathComponent(temporaryFilename)
    do {
        try inString.write(to: temporaryFileURL, atomically: true, encoding: String.Encoding.utf8)
        let stringPath = temporaryFileURL.path
        return stringPath
    } catch {
        throw FileSystemError.tempFileNotWriteable(file: temporaryFileURL.path)
    }
}

func cleanUp(_ tempFile: String) throws {
    if FileManager.default.fileExists(atPath: tempFile) {  // maybe the OS already cleaned it
        do {
            try FileManager.default.removeItem(atPath: tempFile)
        } catch {
            throw FileSystemError.tempFileNotDeletable(file: tempFile)
        }
    }
}

func outputSafetyCheck(destination: String) throws -> Bool {
    if FileManager.default.fileExists(atPath: destination) {
        guard let fileContents = try? String(contentsOfFile: destination) else {
            print("I don't seem to have access to \(destination). Aborting.")
            throw FileSystemError.fileNotReadable(file: destination)
        }
        return fileContents.hasPrefix("**Automated backup of ")
    }
    return true
}
