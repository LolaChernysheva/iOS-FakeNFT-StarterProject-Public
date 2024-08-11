//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import UIKit
import SnapKit
import ProgressHUD

protocol MyNFTViewProtocol: AnyObject {
    func display(data: MyNFTScreenModel, reloadData: Bool)
    func updateLoadingState(isLoading: Bool)
}

final class MyNFTViewController: UIViewController {
    
    typealias Cell = MyNFTScreenModel.TableData.Cell
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    private lazy var emptyViewLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.font = .bodyBold
        label.textAlignment = .center
        return label
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
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
    }
    
    private func setupView() {
        if presenter.nftIds.isEmpty {
            configureEmptyView()
        } else {
            view.addSubview(tableView)
            setupTableView()
            configureTableView()
        }
        configureNavBar()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.tableViewTopOffset)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureEmptyView() {
        view.addSubview(emptyViewLabel)
        
        emptyViewLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CGFloat.emptyViewHeight)
        }
    }
    
    private func configureNavBar() {
        let backButton = UIButton(type: .custom)
        let rightButton = UIButton(type: .custom)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        backButton.setImage(Asset.Images.backward, for: .normal)
        rightButton.setImage(Asset.Images.sort, for: .normal)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = backBarButtonItem
        if !presenter.nftIds.isEmpty {
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
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
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter.sortByPrice()
        }))
        actionSheet.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter.sortByRating()
        }))
        actionSheet.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter.sortByName()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func disableUserInteraction() {
        view.isUserInteractionEnabled = false
    }
    
    private func enableUserInteraction() {
        view.isUserInteractionEnabled = true
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        showActionSheet()
    }
}

extension MyNFTViewController: MyNFTViewProtocol {
    func display(data: MyNFTScreenModel, reloadData: Bool) {
        screenModel = data
        if reloadData {
            tableView.reloadData()
        }
        
    }
    
    func updateLoadingState(isLoading: Bool) {
        if isLoading {
            ProgressHUD.show()
            disableUserInteraction()
        } else {
            ProgressHUD.dismiss()
            enableUserInteraction()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        .cellHeight
    }
    
}

private extension CGFloat {
    static let horizontalOffset = 16.0
    static let cellHeight = 140.0
    static let emptyViewHeight = 22.0
    static let tableViewTopOffset = -20.0
}
