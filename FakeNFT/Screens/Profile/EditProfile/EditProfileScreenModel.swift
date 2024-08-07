//
//  EditProfileScreenModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 16.07.2024.
//  
//

import UIKit

struct EditProfileScreenModel {
    struct TableData {
        enum Section {
            case headeredSection(header: String, cells: [Cell])
        }
        
        enum Cell {
            case textViewCell(TextViewCellModel)
        }
        
        let sections: [Section]
    }
    
    let image: UIImage
    let tableData: TableData
    
    static let empty: EditProfileScreenModel = EditProfileScreenModel(image: UIImage(), tableData: TableData(sections: []))
}
