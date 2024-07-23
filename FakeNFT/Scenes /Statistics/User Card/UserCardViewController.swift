//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCardViewProtocol: AnyObject {

}

final class UserCardViewController: UIViewController {

    var presenter: UserCardPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

// MARK: - UsersCardViewProtocol

extension UserCardViewController: UsersCollectionViewProtocol {

}
