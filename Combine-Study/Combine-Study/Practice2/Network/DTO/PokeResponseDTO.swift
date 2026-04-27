//
//  PokeResponseDTO.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import Foundation

struct PokeListResponseDTO: Codable {
    let count: Int
    let next: String?
    let results: [PokeItemDTO]
}

struct PokeItemDTO: Codable {
    let name: String
    let url: String
}

struct PokeDetailDTO: Codable {
    let id: Int
    let name: String
    let sprites: SpriteDTO
    let types: [TypeEntryDTO]
}

struct SpriteDTO: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeEntryDTO: Codable {
    let type: TypeInfoDTO
}

struct TypeInfoDTO: Codable {
    let name: String
}
