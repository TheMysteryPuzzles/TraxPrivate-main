//
//  VoucherModel.swift
//  Trax
//
//  Created by mac on 25/08/2022.
//

import Foundation

// MARK: - Voucher
struct Voucher: Codable {
    let vID, mID, catID, vName: String
    let vAmount, vDiscount, vQty, vStartDate: String
    let vEndDate, vDuration, vImage, vDesc: String
    let vStatus, mName, mPrefix, mAddress: String
    let mLogo, mDesc, mStatus: String

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
        case vStatus = "v_status"
        case mName = "m_name"
        case mPrefix = "m_prefix"
        case mAddress = "m_address"
        case mLogo = "m_logo"
        case mDesc = "m_desc"
        case mStatus = "m_status"
    }
}
