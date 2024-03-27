//
//  VersionConfig.swift
//  TFTDataFetcher
//
//  Created by FlyKite on 2024/3/27.
//

import Foundation

enum DataUrlType: String, Codable {
    case chess = "urlChessData"
    case race = "urlRaceData"
    case job = "urlJobData"
    case equipment = "urlEquipData"
    case hex = "urlBuffData"
    case galaxy = "urlGalaxyData"
    case adventure = "urlAdventureData"
    
    var name: String {
        switch self {
        case .chess: return "chess"
        case .race: return "race"
        case .job: return "job"
        case .equipment: return "equip"
        case .hex: return "hex"
        case .galaxy: return "galaxy"
        case .adventure: return "adventure"
        }
    }
}

struct VersionConfig: Codable {
    let isPreVersion: Bool
    let arrVersionLimit: [String]
    let stringName: String
    let idSeason: String
    let urlData: [DataUrlType: String]
    
    static func load() throws -> [VersionConfig] {
        let data = try fetch(url: "https://lol.qq.com/zmtftzone/public-lib/versionconfig.json")
        let entities = try JSONDecoder().decode([VersionConfigEntity].self, from: data)
        return entities.map({ VersionConfig(entity: $0) })
    }
    
    private init(entity: VersionConfigEntity) {
        isPreVersion = entity.booleanPreVersion
        arrVersionLimit = entity.arrVersionLimit
        stringName = entity.stringName
        idSeason = entity.idSeason
        var dict: [DataUrlType: String] = [:]
        VersionConfig.setDictValue(&dict, key: .chess, value: entity.urlChessData)
        VersionConfig.setDictValue(&dict, key: .race, value: entity.urlRaceData)
        VersionConfig.setDictValue(&dict, key: .job, value: entity.urlJobData)
        VersionConfig.setDictValue(&dict, key: .equipment, value: entity.urlEquipData)
        VersionConfig.setDictValue(&dict, key: .hex, value: entity.urlBuffData)
        VersionConfig.setDictValue(&dict, key: .galaxy, value: entity.urlGalaxyData)
        VersionConfig.setDictValue(&dict, key: .adventure, value: entity.urlAdventureData)
        urlData = dict
    }
    
    private static func setDictValue(_ dict: inout [DataUrlType: String], key: DataUrlType, value: String?) {
        guard let value = value else { return }
        dict[key] = value
    }
}

struct VersionConfigEntity: TFTDataEntity {
    let booleanPreVersion: Bool
    let arrVersionLimit: [String]
    let stringName: String
    let idSeason: String
    let urlChessData: String?
    let urlRaceData: String?
    let urlJobData: String?
    let urlEquipData: String?
    let urlBuffData: String?
    let urlGalaxyData: String?
    let urlAdventureData: String?
}
