//
//  Equipment.swift
//  TFTLibrary
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

enum EquipmentType: String, Codable {
    /// 基础装备
    case basic = "1"
    /// 成装
    case advanced = "2"
    /// 光明装备
    case light = "3"
    /// 墨之影装备
    case ink = "4"
    /// 无法合成的特殊转职纹章
    case job = "5"
    /// 奥恩神器
    case ornn = "6"
    /// 金鳞龙装备
    case golden = "7"
    /// 辅助装备
    case support = "8"
}

struct Equipment: TFTDataModel {
    
    typealias DataModel = TFTData<EquipmentEntity>
    
    let id: String
    /// 装备类型
    let type: EquipmentType
    /// 名称
    let name: String
    /// 效果
    let effect: String
    /// 关键词
    let keywords: String
    /// 图标Url
    let iconUrl: String
    
    static func parse(from dataModel: DataModel) throws -> [Equipment] {
        return dataModel.data.map({ Equipment(entity: $0) })
    }
    
    private init(entity: EquipmentEntity) {
        id = entity.equipId
        if let t = EquipmentType(rawValue: entity.type) {
            type = t
        } else {
            fatalError("Unsupport EquipmentType")
        }
        name = entity.name
        effect = entity.effect
        keywords = entity.keywords
        iconUrl = entity.imagePath
    }
}

struct EquipmentEntity: TFTDataEntity {
    let TFTID: String
    let jobId: String?
    let isShow: String
    let englishName: String
    let id: String
    let type: String
    let proStatus: String
    let equipId: String
    let keywords: String
    let formula: String
    let raceId: String?
    let effect: String
    let name: String
    let imagePath: String
}
