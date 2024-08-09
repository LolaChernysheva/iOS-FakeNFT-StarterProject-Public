//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import UIKit
import SnapKit

protocol MyNFTViewProtocol: AnyObject {
    func display(data: MyNFTScreenModel, reloadData: Bool)
}

final class MyNFTViewController: UIViewController {
    
    typealias Cell = MyNFTScreenModel.TableData.Cell
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    var presenter: MyNFTPresenterProtocol!
    
    private var screenModel: MyNFTScreenModel = .empty {
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
        view.backgroundColor = .linkBlue
        setupTableView()
        setupView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
    }
    
    private func setupView() {
        view.addSubview(tableView)
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-CGFloat.horizontalOffset)
            make.leading.equalToSuperview().offset(CGFloat.horizontalOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setup() {
        title = screenModel.title
    }
    
    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = screenModel.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }
}

extension MyNFTViewController: MyNFTViewProtocol {
    func display(data: MyNFTScreenModel, reloadData: Bool) {
        screenModel = data
        if reloadData {
            tableView.reloadData()
        }
        
    }
}

//MARK: - UITableViewDelegate

extension MyNFTViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource

extension MyNFTViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .nftCell(model):
            guard let nftCell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else { return UITableViewCell() }
            nftCell.model = model
            cell = nftCell
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }
    
}

private extension CGFloat {
    static let horizontalOffset = 16.0
}
