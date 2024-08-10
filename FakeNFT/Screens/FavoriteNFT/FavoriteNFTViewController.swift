//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 10.08.2024.
//  
//

import UIKit
import SnapKit
import ProgressHUD

protocol FavoriteNFTViewProtocol: AnyObject {
    func display(data: FavoriteNFTScreenModel, reloadData: Bool)
    func updateLoadingState(isLoading: Bool)
}

final class FavoriteNFTViewController: UIViewController {
    
    typealias Section = FavoriteNFTScreenModel.CollectionData.Section
    typealias Cell = FavoriteNFTScreenModel.CollectionData.Cell
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGFloat.itemWidth, height: CGFloat.itemHeight)
        layout.minimumLineSpacing = CGFloat.minimumLineSpacing
        layout.minimumInteritemSpacing = CGFloat.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: CGFloat.horizontalOffset, bottom: 0, right: CGFloat.horizontalOffset)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var presenter: FavoriteNFTPresenterProtocol!
    
    private var model: FavoriteNFTScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }
    
    private func setup() {
        title = model.title
    }
    
    private func setupCollectionView() {
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
    }
    
    private func configureView() {
        configureNavBar()
        setupCollectionView()
        configureCollectionView()
    }
    
    private func configureNavBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(Asset.Images.backward, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func disableUserInteraction() {
        view.isUserInteractionEnabled = false
    }
    
    private func enableUserInteraction() {
        view.isUserInteractionEnabled = true
    }
    
    private func collectionDataCell(indexPath: IndexPath) -> Cell {
        let section = model.collectionData.sections[indexPath.section]
        
        switch section {
        case let .simple(cells):
            return cells[indexPath.item]
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension FavoriteNFTViewController: FavoriteNFTViewProtocol {
    func display(data: FavoriteNFTScreenModel, reloadData: Bool) {
        model = data
        if reloadData {
            collectionView.reloadData()
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

extension FavoriteNFTViewController: UICollectionViewDelegate {
    
}

extension FavoriteNFTViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = collectionDataCell(indexPath: indexPath)
        let cell: UICollectionViewCell
        
        switch cellType {
        case let .nftCell(model):
            guard let nftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
            nftCell.model = model
            cell = nftCell
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model.collectionData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch model.collectionData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }
}

private extension CGFloat {
    static let horizontalOffset: CGFloat = 16.0
    static let minimumLineSpacing: CGFloat = 20.0
    static let minimumInteritemSpacing: CGFloat = 7.0
    static let itemWidth: CGFloat = (UIScreen.main.bounds.width - (2 * horizontalOffset) - minimumInteritemSpacing) / 2
    static let itemHeight: CGFloat = 80.0
    static let emptyViewHeight = 22.0
}
