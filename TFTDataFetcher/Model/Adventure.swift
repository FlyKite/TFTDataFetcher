//
//  Adventure.swift
//  TFTLibrary
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

struct Adventure: TFTDataModel {
    
    typealias DataModel = TFTData<AdventureEntity>
    
    let id: String
    /// 标题（提供奇遇的英雄名称）
    let title: String
    /// 描述
    let description: String
    /// 图标Url
    let iconUrl: String
    
    static func parse(from dataModel: DataModel) throws -> [Adventure] {
        return dataModel.data.map({ Adventure(entity: $0) })
    }
    
    private init(entity: AdventureEntity) {
        id = entity.id
        title = entity.title
        description = entity.desc
        iconUrl = entity.logoUrl
    }
}

struct AdventureEntity: TFTDataEntity {
    let id: String
    let videoUrl: String
    let seasonId: String
    let creater: String
    let logoUrl: String
    let desc: String
    let title: String
    let notes: String
    let imageUrl: String
    let versionId: String
    let createTime: String
    let updater: String
    let isDelete: String
    let updateTime: String
}
