import writingBackupCore

let configFile = BackupConfig(from: "config.toml")
try configFile.convert()

