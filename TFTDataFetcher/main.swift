//
//  main.swift
//  TFTDataFetcher
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

let directoryPath = "\(NSHomeDirectory())/Documents/云顶/S11"

func fetch(url: String) throws -> Data {
    guard let url = URL(string: url) else {
        throw NSError(domain: "Invalid URL: \(url)", code: 1090)
    }
    return try Data(contentsOf: url)
}

func checkAndCreateDirectory(at path: String) throws {
    var isDirectory = ObjCBool(false)
    if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) || !isDirectory.boolValue {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
}

func main() {
    do {
        try checkAndCreateDirectory(at: directoryPath)
        let versionConfigs = try VersionConfig.load()
        guard let currentVersion = versionConfigs.first else { return }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        for (dataType, url) in currentVersion.urlData {
            let data: Data
            switch dataType {
            case .chess:
                data = try encoder.encode(try Chess.load(url: url))
            case .race:
                data = try encoder.encode(try Race.load(url: url))
            case .job:
                data = try encoder.encode(try Job.load(url: url))
            case .equipment:
                data = try encoder.encode(try Equipment.load(url: url))
            case .hex:
                data = try encoder.encode(try Hex.load(url: url))
            case .galaxy:
                continue
            case .adventure:
                data = try encoder.encode(try Adventure.load(url: url))
            }
            try data.write(to: URL(fileURLWithPath: "\(directoryPath)/\(dataType.name).json"))
            print("Fetch \(dataType.name) succeeded")
        }
    } catch {
        print(error)
    }
}

main()
