//
//  DetailCell.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 15.07.2024.
//  
//

import UIKit
import SnapKit

struct DetailCellModel {
    let title: String
    let subtitle: String
    
    var action: () -> Void
}

final class DetailCell: UITableViewCell {
    
    static let identifier = "DetailCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.numberOfLines = 1
        return label
    }()
    
    private let disclosureIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        return imageView
    }()
    
    var model: DetailCellModel? {
        didSet {
            setup()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGuesture()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        guard let model else { return }
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(disclosureIndicatorImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        disclosureIndicatorImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func addGuesture() {
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tapGuesture)
    }
    
    @objc private func tapAction() {
        guard let model else { return }
        model.action()
    }
}
