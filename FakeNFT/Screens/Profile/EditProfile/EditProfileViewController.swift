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
        return imageView
    }()
    
    private lazy var overlayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .caption3
        label.textColor = .white
        return label
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
    }
    
    private func setupConstraints() {
        view.addSubview(avatarImageView)
        view.addSubview(tableView)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch model.tableData.sections[section] {
            
        case .headeredSection(header: let header, _):
            return header
        }
    }
}
