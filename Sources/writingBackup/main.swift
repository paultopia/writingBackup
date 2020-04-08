import writingBackupCore
let configFile = BackupConfig(from: "backup.toml")
try configFile.convert()
