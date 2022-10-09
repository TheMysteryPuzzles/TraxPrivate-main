//
//  MerchantAboutModel.swift
//  Trax
//
//  Created by mac on 26/08/2022.
//

import Foundation

// MARK: - MerchantAbout
struct MerchantAbout: Codable {
    let mID, catID, mName, mPrefix: String
    let mAddress, mLocality, mLong, mLat: String
    let mCountry, mState, mHeadofficecity, mUsername: String
    let mPassword, mPhone, mLogo, mDesc: String
    let mStatus: String

    enum CodingKeys: String, CodingKey {
        case mID = "m_id"
        case catID = "cat_id"
        case mName = "m_name"
        case mPrefix = "m_prefix"
        case mAddress = "m_address"
        case mLocality = "m_locality"
        case mLong = "m_long"
        case mLat = "m_lat"
        case mCountry = "m_country"
        case mState = "m_state"
        case mHeadofficecity = "m_headofficecity"
        case mUsername = "m_username"
        case mPassword = "m_password"
        case mPhone = "m_phone"
        case mLogo = "m_logo"
        case mDesc = "m_desc"
        case mStatus = "m_status"
    }
}

