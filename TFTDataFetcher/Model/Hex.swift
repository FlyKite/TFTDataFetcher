//
//  Hex.swift
//  TFTLibrary
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

enum HexLevel: String, Codable {
    /// 银色海克斯
    case silver = "1"
    /// 金色海克斯
    case golden = "2"
    /// 棱彩海克斯
    case colorful = "3"
}

struct Hex: TFTDataModel {
    
    typealias DataModel = HexData
    
    let id: String
    /// 名称
    let name: String
    /// 海克斯等级
    let level: HexLevel
    /// 描述
    let description: String
    /// 图标Url
    let iconUrl: String
    
    static func parse(from dataModel: DataModel) throws -> [Hex] {
        return dataModel.data.map({ Hex(entity: $0.value) })
    }
    
    private init(entity: HexEntity) {
        id = entity.hexId
        name = entity.name
        if let lv = HexLevel(rawValue: entity.type) {
            level = lv
        } else {
            fatalError("Unsupported HexLevel")
        }
        description = entity.description
        iconUrl = entity.imgUrl
    }
}

struct HexData: TFTOriginalData {
    let modeId: String
    let data: [String: HexEntity]
    let season: String
    let time: String
    let version: String
}

struct HexEntity: TFTDataEntity {
    let id: String
    let hexId: String
    let isShow: String
    let description: String
    let imgUrl: String
    let hero_EN_name: String
    let type: String
    let createTime: String
    let hero_enhancement_type: String
    let augments: String
    let fetterId: String
    let fetterType: String
    let name: String
}
