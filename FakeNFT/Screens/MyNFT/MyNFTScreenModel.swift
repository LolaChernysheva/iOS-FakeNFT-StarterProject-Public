//
//  MyNFTScreenModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import Foundation

struct MyNFTScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }
        
        enum Cell {
            case nftCell(NFTTableViewCellModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    
    static let empty: MyNFTScreenModel = MyNFTScreenModel(title: "", tableData: TableData(sections: []))
}


