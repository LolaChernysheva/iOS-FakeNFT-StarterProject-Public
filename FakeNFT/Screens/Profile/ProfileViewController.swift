//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func display(data: ProfileScreenModel, reloadTableData: Bool)
}

final class ProfileViewController: UIViewController {

    private lazy var profileContainerView = UIView()
    private lazy var avatarImageView = UIImageView()
    private lazy var userNameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var linkTextView = UITextView()
    
    private lazy var tableView = UITableView()
    
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
        configureTableView()
        setupView()
    }
    
    //MARK: - private methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
    }
    
    private func setupView() {
        configireNavBar()
        configureProfileContainer()
    }
    
    private func configireNavBar() {
        let editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func configureProfileContainer() {
        
    }
    
    private func setup() {
        //TODO: -
        /*
         avatarImageView.image = model...
         userNameLabel.text = model...
         descriptionLabel.text = model...
         userWebsiteLabel.text = model...
         */
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
        UITableViewCell()
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
}
