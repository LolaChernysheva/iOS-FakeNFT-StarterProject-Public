//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCollectionPresenterProtocol: AnyObject {

}

final class UserCollectionPresenter {

    weak var view: UsersCollectionViewProtocol?

    init(view: UsersCollectionViewProtocol?) {
        self.view = view
    }
}

// MARK: UsersCollectionPresenterProtocol

extension UserCollectionPresenter: UserCollectionPresenterProtocol {

}
