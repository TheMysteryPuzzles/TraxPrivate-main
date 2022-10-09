//
//  MyHistoryModel.swift
//  Trax
//
//  Created by mac on 01/09/2022.
//


import Foundation

struct MyHistory: Codable {
    let message: [Message]
    let status: Bool
}

// MARK: - Message
struct Message: Codable {
    let redemptionID, userID, couponID, couponIDIssuance: String
    let redemptionDate, vID, bID, transactionID: String
    let couponOffer: String?

    enum CodingKeys: String, CodingKey {
        case redemptionID = "redemption_id"
        case userID = "user_id"
        case couponID = "coupon_id"
        case couponIDIssuance = "coupon_id_issuance"
        case redemptionDate = "redemption_date"
        case vID = "v_id"
        case bID = "b_id"
        case transactionID = "transaction_id"
        case couponOffer = "coupon_offer"
    }
}
