//
//  ViewModelProtocol.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import UIKit

import Combine

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

final class PokeViewModel: ViewModelProtocol {
    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let pokes: AnyPublisher<[PokeModel], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let error: AnyPublisher<String?, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let pokeSubject = CurrentValueSubject<[PokeModel], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .sink { [weak self] _ in
                self?.fetchPokeLists()
            }
            .store(in: &cancellables)
        
        return Output(
            pokes: pokeSubject.eraseToAnyPublisher(), isLoading: isLoadingSubject.eraseToAnyPublisher(), error: errorSubject.eraseToAnyPublisher()
            )
    }
    
    private func fetchPokeLists() {
        isLoadingSubject.send(true)
        
        Task {
            do {
                let pokes = try await PokeService.shared.fetchPokes()
                
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                
                pokeSubject.send(pokes)
                isLoadingSubject.send(false)
            } catch {
                errorSubject.send("데이터 로딩 실패: \(error.localizedDescription)")
                isLoadingSubject.send(false)
            }
        }
    }
}

