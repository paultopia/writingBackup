import writingBackupCore

let inputFile = readConfig()

try PanDocConvert (
  sourceFile: inputFile,
  resultFile: "./output_test.md",
  bibFile: "pgtest.json")

print("Success!")
