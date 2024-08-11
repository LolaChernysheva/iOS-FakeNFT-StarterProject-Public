//
//  PaymentDTO.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 30.07.2024.
//

import Foundation

struct PaymentDTO: Decodable {
    let success: Bool
    let orderId: String?
    let id: String?
}
