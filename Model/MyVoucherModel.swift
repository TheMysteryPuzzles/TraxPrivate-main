//
//  MyVoucherModel.swift
//  Trax
//
//  Created by mac on 30/08/2022.
//

import Foundation

// MARK: - VoucherDetail
struct MyVoucher: Codable {
    let vIDIssuance, userID, vID: String
    

    enum CodingKeys: String, CodingKey {
        case vIDIssuance = "v_id_issuance"
        case userID = "user_id"
        case vID = "v_id"
       
    }
}

