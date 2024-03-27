//
//  Chess.swift
//  TFTLibrary
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

enum ChessImageType {
    /// 小头像
    case head
    /// 完整图片
    case full
}

struct Chess: TFTDataModel {
    
    typealias DataModel = TFTData<ChessEntity>
    
    let id: String
    /// 名称
    let name: String
    /// 图片ID
    let imageId: String
    /// 生命值
    let life: Life
    /// 普攻数据
    let attack: Attack
    /// 暴击率
    let critRate: String
    /// 职业
    let jobs: [RaceJobInfo]
    /// 种族
    let races: [RaceJobInfo]
    /// 技能
    let skill: Skill
    /// 价格
    let price: Int
    
    func getImageUrl(type: ChessImageType) -> String {
        switch type {
        case ChessImageType.head:
            return "https://game.gtimg.cn/images/lol/act/img/tft/champions/\(imageId).png"
        case ChessImageType.full:
            return "https://game.gtimg.cn/images/lol/tftstore/s11/624x318/\(imageId).jpg"
        }
    }
    
//    func getBorderColor() -> UIColor {
//        switch price {
//        case 1: return UIColor(red: 0x99 / 255.0, green: 0x99 / 255.0, blue: 0x99 / 255.0, alpha: 1)
//        case 2: return UIColor(red: 0x5F / 255.0, green: 0xCC / 255.0, blue: 0x29 / 255.0, alpha: 1)
//        case 3: return UIColor(red: 0x29 / 255.0, green: 0x7A / 255.0, blue: 0xCC / 255.0, alpha: 1)
//        case 4: return UIColor(red: 0xCC / 255.0, green: 0x29 / 255.0, blue: 0xCC / 255.0, alpha: 1)
//        case 5: return UIColor(red: 0xCC / 255.0, green: 0xA3 / 255.0, blue: 0x29 / 255.0, alpha: 1)
//        default: return .black
//        }
//    }
    
    struct Attack: Codable {
        /// 攻击力
        let value: String
        /// 攻速
        let speed: String
        /// 攻击距离
        let range: String
        
        fileprivate init(entity: ChessEntity) {
            value = entity.attackData
            speed = entity.attackSpeed
            range = entity.attackRange
        }
    }
    
    struct Life: Codable {
        /// 生命值
        let value: String
        /// 护甲
        let armor: String
        /// 魔抗
        let spellBlock: String
        
        fileprivate init(entity: ChessEntity) {
            value = entity.lifeData
            armor = entity.armor
            spellBlock = entity.spellBlock
        }
    }
    
    struct Skill: Codable {
        /// 技能名称
        let name: String
        /// 技能详情
        let detail: String
        /// 技能图标
        let iconUrl: String
        /// 初始法力值
        let startMagic: String
        /// 释放技能所需法力值
        let magic: String
        
        fileprivate init(entity: ChessEntity) {
            name = entity.skillName
            detail = entity.skillDetail
            iconUrl = entity.skillImage
            startMagic = entity.startMagic
            magic = entity.magic
        }
    }
    
    struct RaceJobInfo: Codable {
        /// ID
        let id: String
        /// 名称
        let name: String
        
        fileprivate static func parse(ids: String, names: String) -> [RaceJobInfo] {
            let idList = ids.components(separatedBy: ",")
            let nameList = names.components(separatedBy: ",")
            var infoList: [RaceJobInfo] = []
            for index in 0 ..< min(idList.count, nameList.count) {
                infoList.append(RaceJobInfo(id: idList[index], name: nameList[index]))
            }
            return infoList
        }
    }
    
    static func parse(from dataModel: DataModel) throws -> [Chess] {
        let result = dataModel.data.filter({ !$0.skillType.isEmpty }).map({ Chess(entity: $0) })
        return result.sorted(by: { (chessA, chessB) in
            if chessA.price == chessB.price {
                return chessA.name.compare(chessB.name) == .orderedAscending
            }
            return chessA.price < chessB.price
        })
    }
    
    private init(entity: ChessEntity) {
        id = entity.chessId
        name = "\(entity.title) \(entity.displayName)"
        imageId = entity.TFTID
        life = Life(entity: entity)
        attack = Attack(entity: entity)
        critRate = entity.crit
        skill = Skill(entity: entity)
        jobs = RaceJobInfo.parse(ids: entity.jobIds, names: entity.jobs)
        races = RaceJobInfo.parse(ids: entity.raceIds, names: entity.races)
        if let p = Int(entity.price) {
            price = p
        } else {
            fatalError("Unsupported price")
        }
    }
}

struct ChessEntity: TFTDataEntity {
    let jobs: String
    let skillName: String
    let startMagic: String
    let races: String
    let id: String
    let attackMag: String
    let proStatus: String
    let attackRange: String
    let attackData: String
    let TFTID: String
    let lifeMag: String
    let chessId: String
    let lifeData: String
    let crit: String
    let hero_EN_name: String
    let name: String
    let jobIds: String
    let synergies: String
    let armor: String
    let spellBlock: String
    let raceIds: String
    let price: String
    let originalImage: String
    let skillIntroduce: String
    let skillImage: String
    let illustrate: String
    let recEquip: String
    let attackSpeed: String
    let skillDetail: String
    let magic: String
    let life: String
    let title: String
    let skillType: String
    let attack: String
    let displayName: String
}
