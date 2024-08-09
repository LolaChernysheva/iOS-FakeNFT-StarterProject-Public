//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    func setup()
}

final class MyNFTPresenter {
    
    private weak var view: MyNFTViewProtocol?
    private var service: MyNftNetworkServiceProtocol?
    
    private var nftIds: [String]
    private var nfts: [NftModel] = []
    
    init(view: MyNFTViewProtocol?, networkService: MyNftNetworkServiceProtocol?, nftIds: [String]) {
        self.view = view
        self.service = networkService
        self.nftIds = nftIds
        loadNfts()
    }
    
    private func buildScreenModel() -> MyNFTScreenModel {
        MyNFTScreenModel(
            title: NSLocalizedString("Мои NFT", comment: ""),
            tableData: .init(sections: buildNftsSection())
        )
    }
    
    private func buildNftsSection() -> [MyNFTScreenModel.TableData.Section] {
        let cells: [MyNFTScreenModel.TableData.Cell] = nfts.map { nft in
            .nftCell(NFTTableViewCellModel(
                image: nft.imageString,
                name: nft.name,
                authorName: nft.authorName,
                price: String("\(nft.price)"),
                rating: nft.rating,
                isLiked: nft.isLiked
            ))
        }
        return [.simple(cells: cells)]
    }
    
    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadData: reloadData)
    }
    
    private func loadNfts() {
        nftIds.forEach { id in
            service?.fetchNft(id: id, completion: { [ weak self ] result in
                guard let self else { return }
                switch result {
                case let .success(nft):
                    self.nfts.append(
                        NftModel(
                            name: nft.name,
                            rating: nft.rating,
                            authorName: nft.author,
                            price: nft.price,
                            imageString: nft.images.first ?? "",
                            isLiked: false) //TODO: -
                    )
                    render()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            })
            
        }
    }
    
}

extension MyNFTPresenter: MyNFTPresenterProtocol {
    func setup() {
        render()
    }
}
