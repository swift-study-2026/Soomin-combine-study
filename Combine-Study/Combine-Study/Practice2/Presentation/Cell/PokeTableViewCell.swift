//
//  PokeTableViewCell.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

class PokeTableViewCell: UITableViewCell {
    
    static let identifier = "PokeTableViewCell"
    
    private let pokeImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    
    private let nameLabel = UILabel().then{
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    
    private let typeLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private let arrowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [pokeImageView, nameLabel, typeLabel, arrowButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        pokeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(pokeImageView.snp.trailing).offset(20)
            $0.top.equalToSuperview().inset(22)
        }
        
        typeLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(22)
        }
        
        arrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
}

extension PokeTableViewCell {
    func dataBind(_ model: PokeModel) {
        if let url = URL(string: model.imageURL) {
            pokeImageView.kf.setImage(with: url)
        }
        nameLabel.text = model.name
        typeLabel.text = model.typeName
    }
}
