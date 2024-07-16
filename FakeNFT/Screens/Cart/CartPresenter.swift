//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    
}

final class CartPresenter {
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    
}
