//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit
import SnapKit

protocol ProfileViewProtocol: AnyObject {
    func display(data: ProfileScreenModel, reloadTableData: Bool)
}

final class ProfileViewController: UIViewController {
    
    typealias Cell = ProfileScreenModel.TableData.Cell

    private lazy var profileContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .headline3
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .caption2
        return label
    }()
    
    private lazy var linkTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        return textView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - public properties
    
    var presenter: ProfilePresenterProtocol!
    
    //MARK: - private properties
    
    private var model: ProfileScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    //MARK: life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.setup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupView()
    }
    
    //MARK: - private methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        linkTextView.delegate = self
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
    }
    
    private func setupView() {
        view.addSubview(profileContainerView)
        view.addSubview(tableView)
        configireNavBar()
        configureProfileContainer()
        configureTableView()

    }
    
    private func configireNavBar() {
        let editButton = UIBarButtonItem(image: Asset.Images.edit?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func configureProfileContainer() {
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 16
        horizontalStack.addArrangedSubview(avatarImageView)
        horizontalStack.addArrangedSubview(userNameLabel)
        
        profileContainerView.addArrangedSubview(horizontalStack)
        profileContainerView.addArrangedSubview(descriptionLabel)
        profileContainerView.addArrangedSubview(linkTextView)
        
        profileContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
    }
    
    private func configureTableView() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileContainerView.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setup() {
        avatarImageView.image = model.userImage
        userNameLabel.text = model.userName
        descriptionLabel.text = model.userAbout
        let attributedString = NSMutableAttributedString(string: "\(model.websiteUrlString)")
        attributedString.addAttribute(.link, value: "https://www.apple.com", range: NSRange(location: 6, length: 5)) //TODO: - 
        linkTextView.attributedText = attributedString
    }
    
    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = model.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }
    
    @objc private func editButtonTapped() {
        
    }
}

//MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func display(data: ProfileScreenModel, reloadTableData: Bool) {
        model = data
        if reloadTableData {
            tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .detail(model):
            guard let detailCell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell else { return UITableViewCell() }
            detailCell.model = model
            cell = detailCell
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}

//MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("Link tapped: \(URL)")
        return true
    }
}
