//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func setup()
}

final class ProfilePresenter {
    
    typealias Cell = ProfileScreenModel.TableData.Cell
    
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    private func buildScreenModel() -> ProfileScreenModel {
        ProfileScreenModel(
            userName: "Joaquin Phoenix",
            userImage: Asset.Images.tabBarProfile ?? UIImage(),
            userAbout: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            websiteUrlString: "Joaquin Phoenix.com",
            tableData: ProfileScreenModel.TableData(sections: [
                .simple(cells: [
                    buildMyNFTCell(),
                    buildFavorieNFTCell(),
                    buildAboutDeveloperCell()
                ])
            ])
        )
    }
    
    private func buildMyNFTCell() -> Cell {
        .detail(DetailCellModel(
            title: NSLocalizedString("Мои NFT", comment: ""),
            subtitle: "(112)",
            action: {
                
            }))
    }
    
    private func buildFavorieNFTCell() -> Cell {
        .detail(DetailCellModel(
            title: NSLocalizedString("Избранные NFT", comment: ""),
            subtitle: "(11)",
            action: {
                
            }))
    }
    
    private func buildAboutDeveloperCell() -> Cell {
        .detail(DetailCellModel(
            title: NSLocalizedString("О разработчике", comment: ""),
            subtitle: "",
            action: {
                
            }))
    }
    
    private func render(reloadTableData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadTableData)
    }
}

//MARK: ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    func setup() {
        render()
    }
}
