//
//  MyCouponModel.swift
//  Trax
//
//  Created by mac on 30/08/2022.
//

import Foundation

import Foundation

// MARK: - MyCoupon
struct MyCoupon: Codable {
    let couponIDIssuance, vIssuanceSerial, couponID, couponQtyIssuance: String
    let userID, couponOffer, couponImage, couponDiscount: String

    enum CodingKeys: String, CodingKey {
        case couponIDIssuance = "coupon_id_issuance"
        case vIssuanceSerial = "v_issuance_serial"
        case couponID = "coupon_id"
        case couponQtyIssuance = "coupon_qty_issuance"
        case userID = "user_id"
        case couponOffer = "coupon_offer"
        case couponImage = "coupon_image"
        case couponDiscount = "coupon_discount"
    }
}

