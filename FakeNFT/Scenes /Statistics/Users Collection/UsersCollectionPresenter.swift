//
//  UsersCollectionPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UsersCollectionPresenterProtocol: AnyObject {

}

final class UsersCollectionPresenter {

    weak var view: UsersCollectionViewProtocol?

    init(view: UsersCollectionViewProtocol?) {
        self.view = view
    }
}

// MARK: UsersCollectionPresenterProtocol

extension UsersCollectionPresenter: UsersCollectionPresenterProtocol {

}
