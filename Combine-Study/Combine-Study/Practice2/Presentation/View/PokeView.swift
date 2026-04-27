//
//  PokeView.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import UIKit

import SnapKit
import Then

final class PokeView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = 120
    }
    
    let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .systemMint
        $0.hidesWhenStopped = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setUI()
        setLayout()
        register()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [tableView, loadingIndicator].forEach {
            addSubview($0)
        }
    }
    
    private func setLayout(){
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func register() {
        tableView.register(PokeTableViewCell.self, forCellReuseIdentifier: PokeTableViewCell.identifier)
    }
}
