enum FileSystemError: Error {
    case fileNotReadable(file: String)
    case tempFileNotWriteable(file: String)
    case configFileNotParseable
    case configFileMisformatted(key: String)
    case pandocFailure(message: String)
}
