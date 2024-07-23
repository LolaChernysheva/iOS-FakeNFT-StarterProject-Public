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

final class UsersCollectionViewController: UIViewController {

    var presenter: UsersCollectionPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

// MARK: - UsersCollectionViewProtocol

extension StatisticsViewController: UsersCollectionViewProtocol {

}
