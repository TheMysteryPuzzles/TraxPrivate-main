
//  CouponModel.swift
//  Trax

//  Created by mac on 26/08/2022.


import Foundation

// MARK: - Coupon
struct Coupon: Codable {
    let couponID, vID, couponOffer, couponDetail: String
    let couponQty, couponStatus, couponStartDate, couponEndDate: String
    let couponImage, createdAt, updatedAt: String
    let discount: String
    let validityString: String
    let deletedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case couponID = "coupon_id"
        case vID = "v_id"
        case couponOffer = "coupon_offer"
        case couponDetail = "coupon_detail"
        case couponQty = "coupon_qty"
        case couponStatus = "coupon_status"
        case couponStartDate = "coupon_start_date"
        case couponEndDate = "coupon_end_date"
        case couponImage = "coupon_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case discount  = "coupon_discount"
        case validityString = "valid_days_str"
    }
}
