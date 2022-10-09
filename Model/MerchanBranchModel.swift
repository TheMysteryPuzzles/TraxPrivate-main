//
//  MerchanBranchModel.swift
//  Trax
//
//  Created by mac on 26/08/2022.
//

import Foundation

// MARK: - Branches
struct Branch: Codable {
    let bID, mID, bTitle, bAddress: String
    let bPhone, bState, bCity, bLocality: String
    let bLong, bLat, bStartTime, bEndTime: String
    let bUsername, bPassword, bImage, bStatus: String
    

    enum CodingKeys: String, CodingKey {
        case bID = "b_id"
        case mID = "m_id"
        case bTitle = "b_title"
        case bAddress = "b_address"
        case bPhone = "b_phone"
        case bState = "b_state"
        case bCity = "b_city"
        case bLocality = "b_locality"
        case bLong = "b_long"
        case bLat = "b_lat"
        case bStartTime = "b_start_time"
        case bEndTime = "b_end_time"
        case bUsername = "b_username"
        case bPassword = "b_password"
        case bImage = "b_image"
        case bStatus = "b_status"
       
    }
}

