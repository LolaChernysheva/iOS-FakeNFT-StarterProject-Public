//
//  TextViewCell.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 16.07.2024.
//  
//

import UIKit
import SnapKit

struct TextViewCellModel {
    var text: String
}

final class TextViewCell: UITableViewCell {
    static let identifier = "TextViewCell"
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = true
        textView.textColor = .black
        return textView
    }()
    
    var model: TextViewCellModel? {
        didSet {
            setup()
        }
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .segmentInactive
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setup() {
        guard let model else {return}
        textView.text = model.text
    }
}
