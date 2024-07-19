//
//  CartStubView.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 19.07.2024.
//

import UIKit
import SnapKit

final class CartStubView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    init(text: String) {
        label.text = text
        super.init(frame: .zero)

        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
