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
    func saveChanges()
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    typealias Section = EditProfileScreenModel.TableData.Section
    
    private weak var view: EditProfileViewProtocol?
    private var profile: Profile
    private var networkService: ProfileNetworkServiceProtocol?
    
    init(
        view: EditProfileViewProtocol?,
        profile: Profile,
        networkService: ProfileNetworkServiceProtocol?
    ) {
        self.view = view
        self.profile = profile
        self.networkService = networkService
    }
    
    private func buildScreenModel() -> EditProfileScreenModel {
        EditProfileScreenModel(
            image: profile.avatar,
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
                            .textFieldCell(TextFieldCellModel(
                                text: profile.name,
                                textDidChanged: { [ weak self ] name in
                                    guard let self else { return }
                                    DispatchQueue.global().sync {
                                        self.profile.name = name
                                    }
                                }))
                         ])
    }
    
    private func buildDescriptionSection() -> Section {
        .headeredSection(
            header: NSLocalizedString("Описание", comment: ""),
            cells: [
                .textViewCell(
                    TextViewCellModel(
                        text: profile.description,
                        textDidChanged: { [weak self] description in
                            guard let self else { return }
                            DispatchQueue.global().sync {
                                self.profile.description = description
                            }
                        }
                    )
                )
            ]
        )
    }
    
    private func buildSiteSection() -> Section {
        .headeredSection(header: NSLocalizedString("Сайт", comment: ""),
                         cells: [
                            .textFieldCell(TextFieldCellModel(
                                text: profile.website,
                                textDidChanged: { [ weak self ] website in
                                    guard let self else { return }
                                    DispatchQueue.global().sync {
                                        self.profile.website = website
                                    }
                                }))
                         ])
    }
    
    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadData)
    }
    
    private func updateProfileInfo(profile: Profile) {
        networkService?.updateProfile(profile: profile, completion: { result in
            switch result {
            case let .success(profile):
                print("profile info successfully updated")
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func setup() {
        render()
    }
    
    func saveChanges() {
        updateProfileInfo(profile: profile)
    }
}


