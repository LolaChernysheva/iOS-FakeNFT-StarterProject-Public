//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 16.07.2024.
//  
//

import UIKit

protocol EditProfilePresenterProtocol: AnyObject {
    func setup()
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    typealias Section = EditProfileScreenModel.TableData.Section
    private weak var view: EditProfileViewProtocol?
    
    init(view: EditProfileViewProtocol?) {
        self.view = view
    }
    
    private func buildScreenModel() -> EditProfileScreenModel {
        EditProfileScreenModel(
            image: UIImage(), //TODO: -
            tableData: EditProfileScreenModel.TableData(sections: [
                buildNameSection(),
                buildDescriptionSection(),
                buildSiteSection()
            ])
        )
    }
    
    private func buildNameSection() -> Section {
        .headeredSection(header: NSLocalizedString("Имя", comment: ""),
                         cells: [
                            .textViewCell(TextViewCellModel(text: "Joaquin Phoenix")) //TODO: -
                         ])
    }
    
    private func buildDescriptionSection() -> Section {
        .headeredSection(header: NSLocalizedString("Описание", comment: ""),
                         cells: [
                            .textViewCell(TextViewCellModel(text: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,и еще больше — на моём сайте. Открыт к коллаборациям.")) //TODO: -
                         ])
    }
    
    private func buildSiteSection() -> Section {
        .headeredSection(header: NSLocalizedString("Сайт", comment: ""),
                         cells: [
                            .textViewCell(TextViewCellModel(text: "Joaquin Phoenix.com")) //TODO: -
                         ])
    }
    
    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadData)
    }
    
    func setup() {
        render()
    }
}


