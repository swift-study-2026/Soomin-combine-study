//
//  LoginViewController.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import UIKit

import Combine
import SnapKit
import Then

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일 입력"
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호 입력"
    }
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var loginButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.titleLabel?.textColor = .white
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .lightGray
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModel()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        [emailTextField, passwordTextField, loginButton, indicator].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayout() {
        emailTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(100)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        indicator.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        emailTextField.publisher(for: \.text)
            .compactMap { $0 }
            .sink { [weak self] text in
                self?.viewModel.email = text
            }
            .store(in: &cancellables)
        
        passwordTextField.publisher(for: \.text)
            .compactMap { $0 }
            .sink { [weak self] text in
                self?.viewModel.password = text
            }
            .store(in: &cancellables)
        
        viewModel.isButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.loginButton.isEnabled = isEnabled
                self?.loginButton.backgroundColor = isEnabled ? .blue : .lightGray
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.indicator.startAnimating()
                    self?.loginButton.alpha = 0.5
                } else {
                    self?.indicator.stopAnimating()
                    self?.loginButton.alpha = 1.0
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.loginButtonTapped.send()
    }
}


