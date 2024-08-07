//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 16.07.2024.
//  
//

import UIKit
import SnapKit

protocol EditProfileViewProtocol: AnyObject {
    func display(data: EditProfileScreenModel, reloadTableData: Bool)
}

final class EditProfileViewController: UIViewController {
    
    typealias Cell = EditProfileScreenModel.TableData.Cell
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.avatarRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var overlayLabel: UILabel = {
        let label = UILabel()
        label.text = "Сменить \nфото"
        label.numberOfLines = 0
        label.font = .caption3
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var darkOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        view.layer.cornerRadius = Constants.avatarRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    
    private var model: EditProfileScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    var presenter: EditProfilePresenter!
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupTapGesture()
    }
    
    private func setupView() {
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(TextViewCell.self, forCellReuseIdentifier: TextViewCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    private func setupConstraints() {
        view.addSubview(avatarImageView)
        view.addSubview(tableView)
        avatarImageView.addSubview(darkOverlay)
        darkOverlay.addSubview(overlayLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.avatarTopOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.avatarSize)
            make.height.equalTo(Constants.avatarSize)
        }
        
        darkOverlay.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        overlayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.tableViewTopInsets)
            make.leading.equalToSuperview().offset(Constants.horizontalInsets)
            make.trailing.equalToSuperview().offset(-Constants.horizontalInsets)
            make.bottom.equalToSuperview().offset(-Constants.horizontalInsets)
        }
    }
    
    private func setup() {
        avatarImageView.image = model.image
    }
    
    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = model.tableData.sections[indexPath.section]
        
        switch section {
        case .headeredSection(_, cells: let cells):
            return cells[indexPath.row]
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - EditProfileViewProtocol

extension EditProfileViewController: EditProfileViewProtocol {
    func display(data: EditProfileScreenModel, reloadTableData: Bool) {
        model = data
        if reloadTableData {
            tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        model.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.tableData.sections[section] {
        case .headeredSection(_, cells: let cells):
            return cells.count
        }
    }
}

//MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .textViewCell(model):
            guard let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier, for: indexPath) as? TextViewCell else { return UITableViewCell() }
            textViewCell.model = model
            cell = textViewCell
        case let .textFieldCell(model):
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            textFieldCell.model = model
            cell = textFieldCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier) as? HeaderView else {
            return nil
        }
        
        let headerText: String
        
        switch model.tableData.sections[section] {
        case .headeredSection(header: let header, _):
            headerText = header
        }
        
        headerView.configure(with: headerText)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private struct Constants {
    static let avatarRadius: CGFloat = 35
    static let avatarTopOffset: CGFloat = 80
    static let avatarSize: CGFloat = 70
    static let horizontalInsets: CGFloat = 16
    static let tableViewTopInsets: CGFloat = 24
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
