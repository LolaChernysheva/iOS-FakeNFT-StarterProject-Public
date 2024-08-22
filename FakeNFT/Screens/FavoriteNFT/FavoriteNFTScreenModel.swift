//
//  FavoriteNFTScreenModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 10.08.2024.
//  
//

import Foundation

struct FavoriteNFTScreenModel {
    struct CollectionData {
        enum Section {
            case simple(cells: [Cell])
        }
        
        enum Cell {
            case nftCell(NFTCollectionViewCellModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let collectionData: CollectionData
    
    static let empty: FavoriteNFTScreenModel = FavoriteNFTScreenModel(title: "", collectionData: CollectionData(sections: []))
}
