//
//  TFTData.swift
//  TFTLibrary
//
//  Created by FlyKite on 2024/3/22.
//

import Foundation

protocol TFTDataModel: Codable {
    associatedtype DataModel: TFTOriginalData
    static func parse(from dataModel: DataModel) throws -> [Self]
}

extension TFTDataModel {
    static func load(url: String) throws -> [Self] {
        let data = try fetch(url: url)
        return try parse(from: try JSONDecoder().decode(DataModel.self, from: data))
    }
}

protocol TFTOriginalData: Codable { }

protocol TFTDataEntity: Codable { }

struct TFTData<Entity: TFTDataEntity>: TFTOriginalData {
    let modeId: String
    let data: [Entity]
    let season: String
    let time: String
    let version: String
}
