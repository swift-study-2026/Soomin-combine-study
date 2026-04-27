//
//  PokeService.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import Foundation

final class PokeService {
    static let shared = PokeService()
    private init() {}
    
    func makeRequest(limit: Int = 20) -> URLRequest? {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
        
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func fetchPokes() async throws -> [PokeModel] {
        guard let request = makeRequest() else { throw NetworkError.requestEncodingError }
        let (data, _) = try await URLSession.shared.data(for: request)
        let listDecoded = try JSONDecoder().decode(PokeListResponseDTO.self, from: data)
        
        return try await withThrowingTaskGroup(of: PokeModel.self) { group in
            for item in listDecoded.results {
                group.addTask {
                    let (detailData, _) = try await URLSession.shared.data(from: URL(string: item.url)!)
                    let detailDTO = try JSONDecoder().decode(PokeDetailDTO.self, from: detailData)
                    return PokeModel(dto: detailDTO)
                }
            }
            
            var models: [PokeModel] = []
            for try await model in group {
                models.append(model)
            }
            return models
        }
    }
}
