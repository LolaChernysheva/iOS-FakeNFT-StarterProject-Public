//
//  HeaderView.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 07.08.2024.
//  
//

import UIKit
import SnapKit

final class HeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "HeaderView"
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        contentView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.verticalInsets)
            make.bottom.equalToSuperview().offset(-Constants.verticalInsets)
        }
    }
    
    func configure(with text: String) {
        headerLabel.text = text
    }
}

private struct Constants {
    static let verticalInsets: CGFloat = 8
}
