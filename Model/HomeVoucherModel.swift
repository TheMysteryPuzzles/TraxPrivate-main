//
//  HomeVoucherModel.swift
//  Trax
//
//  Created by mac on 03/09/2022.
//

import Foundation

// MARK: - HomeVoucher
struct HomeVoucher: Codable {
    let vID, mID, catID, vName: String
    let vAmount, vDiscount, vQty, vStartDate: String
    let vEndDate, vDuration, vImage, vDesc: String
    let termsConditions, vStatus, createdAt, updatedAt: String
    let isDeal, isNew, isBest: String

    enum CodingKeys: String, CodingKey {
        case vID = "v_id"
        case mID = "m_id"
        case catID = "cat_id"
        case vName = "v_name"
        case vAmount = "v_amount"
        case vDiscount = "v_discount"
        case vQty = "v_qty"
        case vStartDate = "v_start_date"
        case vEndDate = "v_end_date"
        case vDuration = "v_duration"
        case vImage = "v_image"
        case vDesc = "v_desc"
        case termsConditions = "terms_conditions"
        case vStatus = "v_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isDeal = "is_deal"
        case isNew = "is_new"
        case isBest = "is_best"
    }
}
