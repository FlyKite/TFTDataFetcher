//
//  Job.swift
//  TFTLibrary
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

enum JobColor: String, Codable {
    case level1 = "1"
    case level2 = "2"
    case level3 = "3"
    case level4 = "4"
    case level5 = "5"
}

struct Job: TFTDataModel, Hashable {
    
    typealias DataModel = TFTData<JobEntity>
    
    let id: String
    /// 名称
    let name: String
    /// 介绍
    let introduce: String
    /// 等级
    let levels: [Level]
    /// 图标Url
    let iconUrl: String
    
    struct Level: Codable {
        /// 所需棋子数量
        let chessCount: Int
        /// 效果描述
        let description: String
        /// 等级对应的颜色
        let color: JobColor
    }
    
    static func parse(from dataModel: DataModel) throws -> [Job] {
        return dataModel.data.filter({ !$0.characterid.isEmpty }).map({ Job(entity: $0) })
    }
    
    private init(entity: JobEntity) {
        id = entity.jobId
        name = entity.name
        introduce = entity.introduce
        let levelColorList = entity.job_color_list.components(separatedBy: ",")
        var levelColorDict: [String: JobColor] = [:]
        for levelColorDesc in levelColorList {
            let components = levelColorDesc.components(separatedBy: ":")
            if let color = JobColor(rawValue: components[1]) {
                levelColorDict[components[0]] = color
            } else {
                fatalError("Unsupported color")
            }
        }
        levels = entity.level.map({ keyValue in
            guard let chessCount = Int(keyValue.key) else {
                fatalError("Chess count invalid")
            }
            guard let color = levelColorDict[keyValue.key] else {
                fatalError("Job color not found")
            }
            return Level(chessCount: chessCount, description: keyValue.value, color: color)
        }).sorted(by: { levelA, levelB in
            return levelA.chessCount < levelB.chessCount
        })
        iconUrl = entity.imagePath
    }
    
    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct JobEntity: TFTDataEntity {
    let introduce: String
    let alias: String
    let TFTID: String
    let traitId: String
    let level: [String: String]
    let id: String
    let imagePath: String
    let job_color_list: String
    let jobId: String
    let name: String
    let characterid: String
}
