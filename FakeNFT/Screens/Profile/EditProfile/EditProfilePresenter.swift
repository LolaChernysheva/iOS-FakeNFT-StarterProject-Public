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
    private var profile: Profile?
    
    
    init(view: EditProfileViewProtocol?, profile: Profile?) {
        self.view = view
        self.profile = profile
    }
    
    private func buildScreenModel() -> EditProfileScreenModel {
        EditProfileScreenModel(
            image: profile?.avatar ?? UIImage(),
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
                            .textViewCell(TextViewCellModel(text: profile?.name ?? ""))
                         ])
    }
    
    private func buildDescriptionSection() -> Section {
        .headeredSection(header: NSLocalizedString("Описание", comment: ""),
                         cells: [
                            .textViewCell(TextViewCellModel(text: profile?.description ?? ""))
                         ])
    }
    
    private func buildSiteSection() -> Section {
        .headeredSection(header: NSLocalizedString("Сайт", comment: ""),
                         cells: [
                            .textViewCell(TextViewCellModel(text: profile?.website ?? ""))
                         ])
    }
    
    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadData)
    }
    
    func setup() {
        render()
    }
}


