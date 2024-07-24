//
//  UsersCollectionViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UsersCollectionViewProtocol: AnyObject {

}

final class UserCollectionViewController: UIViewController {

    var presenter: UsersCollectionPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            view.backgroundColor = .systemMint
        } else {
            view.backgroundColor = .lightGray
        }
        
    }
}

// MARK: - UsersCollectionViewProtocol

extension StatisticsViewController: UsersCollectionViewProtocol {

}
