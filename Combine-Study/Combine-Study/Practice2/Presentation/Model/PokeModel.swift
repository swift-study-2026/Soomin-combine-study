//
//  PokeModel.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import Foundation

struct PokeModel {
    let id: Int
    let name: String
    let imageURL: String
    let typeName: String
}

extension PokeModel {
    init(dto: PokeDetailDTO) {
        self.id = dto.id
        self.name = dto.name
        self.imageURL = dto.sprites.frontDefault
        self.typeName = dto.types.first?.type.name ?? "?"
    }
}
