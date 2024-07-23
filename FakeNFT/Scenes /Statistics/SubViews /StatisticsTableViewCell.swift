//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 19.07.2024.
//

import Foundation
import UIKit
import SnapKit

final class StatisticsTableViewCell: UITableViewCell {

    private var userAvatarImageView = UIImageView()
    private var userNameLabel = UILabel()
    private var nftAmountLabel = UILabel()
    private let cellIndex = UILabel()
    private let horizontalStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor(named: "FakeWhite")
        setupUI()
        prepareUserNameLabel()
        prepareNFTAmonuntLabel()
        prepareUserAvatarImageView()
        prepareCellIndexLabel()
        prepareHorizontalStack()
        activatingConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        for subView in [horizontalStack, userAvatarImageView, userNameLabel, nftAmountLabel, cellIndex] {
            subView.translatesAutoresizingMaskIntoConstraints = false

            if subView == horizontalStack || subView == cellIndex {
                self.addSubview(subView)
            } else {
                horizontalStack.addArrangedSubview(subView)
            }
        }

        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
    }
    private func activatingConstraints() {
        cellIndex.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(27)
        }
        horizontalStack.snp.makeConstraints { make in
            make.leading.equalTo(cellIndex.snp.trailing).inset(8)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        userAvatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(28)
        }
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userAvatarImageView.snp.trailing).inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
        nftAmountLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.trailing).inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }

    }
    private func prepareUserAvatarImageView() {
        userAvatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        userAvatarImageView.layer.cornerRadius = 28
        userAvatarImageView.image = UIImage(systemName: "person")

    }
    private func prepareUserNameLabel() {

        userNameLabel.textAlignment = .natural
        userNameLabel.font = .headline3
        userNameLabel.textColor = UIColor(named: "FakeBlack")
    }
    private func prepareNFTAmonuntLabel() {
        nftAmountLabel.textAlignment = .center
        nftAmountLabel.font = .headline3
        nftAmountLabel.textColor = UIColor(named: "FakeBlack")
    }
    private func prepareCellIndexLabel() {
        nftAmountLabel.textAlignment = .center
        nftAmountLabel.font = .caption1
        nftAmountLabel.textColor = UIColor(named: "FakeBlack")
    }
    private func prepareHorizontalStack() {
       horizontalStack.axis = .horizontal
       horizontalStack.spacing = 0
        horizontalStack.backgroundColor = UIColor(named: "FakeLightGray")
        horizontalStack.layer.cornerRadius = 12
    }

}
