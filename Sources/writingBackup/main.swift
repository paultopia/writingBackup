import writingBackupCore
import Foundation

let inputFile = readConfig()

try PanDocConvert (
  sourceFile: inputFile,
  resultFile: "output_test.md",
  //resultFile: "~/writingbackup_output_test.md", WORKS
  bibFile: "pgtest.json")

// let foo = try combineFiles(files: ["testdoc.md", "secondfile.md"])

// print(foo)

// print(NSString("~Dropbox/").expandingTildeInPath)

print("Success!")
