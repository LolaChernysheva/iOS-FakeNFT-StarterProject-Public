//
//  CurrenciesPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import Foundation

protocol CurrenciesPresenterProtocol {
    func setupData()
}

final class CurrenciesPresenter: CurrenciesPresenterProtocol {
    weak var view: CurrenciesViewControllerProtocol?
    
    func setupData() {
        
    }
}
