import writingBackupCore
import Foundation

// let inputFile = readConfig()

// try PanDocConvert (
  // sourceFile: inputFile,
  // resultFile: "output_test.md",
  // bibFile: "pgtest.json")

// let foo = try combineFiles(files: ["testdoc.md", "secondfile.md"])

// print(foo)


//resultFile: "~/writingbackup_output_test.md", WORKS

//print("Success!")

let configFile = BackupConfig(from: "config.toml")
try configFile.convert()
// print(configFile.inFiles)
// print(configFile.outFile)
// print(configFile.bibFile)
// print(configFile.combinedTempString)

// makeTempFile(with: "test")
