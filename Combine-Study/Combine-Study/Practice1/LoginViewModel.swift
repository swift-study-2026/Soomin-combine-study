//
//  LoginViewModel.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import Combine
import Foundation

class LoginViewModel {
    @Published var email = ""
    @Published var password = ""
    
    let isLoading = PassthroughSubject<Bool, Never>()
    let loginButtonTapped = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var isButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return email.contains("@") && password.count >= 6
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        loginButtonTapped
            .sink { [weak self] in
                self?.login()
            }
            .store(in: &cancellables)
    }
    
    private func login() {
        isLoading.send(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading.send(false)
        }
    }
}
