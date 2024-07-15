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
    
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    private func buildScreenModel() -> ProfileScreenModel {
        ProfileScreenModel(
            editProfileImage: UIImage(),
            userName: "",
            userImage: UIImage(),
            userAbout: "",
            websiteUrlString: "",
            tableData: ProfileScreenModel.TableData(sections: [
                .simple(cells: [
                    
                ])
            ])
        )
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
