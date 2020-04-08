public func combineFiles(files: [String]) throws -> String {
    let strings = try files.map { try String(contentsOfFile: $0) }
    return strings.joined(separator: "\n\n")
}
