//
//  CartItemModel.swift
//  Trax
//
//  Created by mac on 29/08/2022.
//

import Foundation

// MARK: - CartItem
struct CartItem: Codable {
    let data: [Datum]
    let totalAmount: String

    enum CodingKeys: String, CodingKey {
        case data
        case totalAmount = "total_amount"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let userID, vID, vAmount, vName, vimage, vdiscount: String
    

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case vID = "v_id"
        case vAmount = "v_amount"
        case vName = "v_name"
        case vimage = "v_image"
        case vdiscount = "v_discount"
    }
}
