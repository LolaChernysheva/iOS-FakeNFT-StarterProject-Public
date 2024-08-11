//
//  UserDefaultsManager.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 11.08.2024.
//  
//

import Foundation

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private enum Keys: String {
        case sortTypeKey
    }
    
    func saveSortType(_ sortType: SortType) {
        UserDefaults.standard.set(sortType.rawValue, forKey: Keys.sortTypeKey.rawValue)
    }
    
    func loadSortType() -> SortType? {
        guard let rawValue = UserDefaults.standard.string(forKey: Keys.sortTypeKey.rawValue) else {
            return nil
        }
        return SortType(rawValue: rawValue)
    }
    
    func hasSavedSortType() -> Bool {
        return UserDefaults.standard.string(forKey: Keys.sortTypeKey.rawValue) != nil
    }
}

enum SortType: String {
    case byPrice
    case byRating
    case byName
}


