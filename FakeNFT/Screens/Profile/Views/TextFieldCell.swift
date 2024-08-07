//
//  TextFieldCell.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 07.08.2024.
//  
//

import UIKit
import SnapKit

struct TextFieldCellModel {
    var text: String
}

final class TextFieldCell: UITableViewCell {
    static let identifier = "TextFieldCell"
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.font = .bodyRegular
        textField.textColor = .black
        return textField
    }()
    
    var model: TextFieldCellModel? {
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
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.horizontalInsets)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.height)
        }
    }
    
    private func setup() {
        guard let model else {return}
        textField.text = model.text
    }
}

private struct Constants {
    static let horizontalInsets: CGFloat = 16
    static let height: CGFloat = 44
}
