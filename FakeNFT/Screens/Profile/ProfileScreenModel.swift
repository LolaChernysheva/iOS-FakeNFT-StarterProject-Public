//
//  ProfileScreenModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit

struct ProfileScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }
        
        enum Cell {
            case detail(DetailCellModel)
        }
        
        let sections: [Section]
    }
    
    let userName: String
    let userImage: UIImage
    let userAbout: String
    let websiteUrlString: String
    let tableData: TableData
    
    static let empty = ProfileScreenModel(
        userName: "",
        userImage: UIImage(),
        userAbout: "",
        websiteUrlString: "",
        tableData: TableData(sections: [])
    )
}
