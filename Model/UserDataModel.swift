//
//  UserDataModel.swift
//  Trax
//
//  Created by mac on 26/08/2022.
//

import Foundation

// MARK: - UserData
struct UserData: Codable {
    let message: String
    let status: Bool
    let userData: [UserDataClass]

    enum CodingKeys: String, CodingKey {
        case message, status
        case userData = "user_data"
    }
}

// MARK: - UserDataClass
struct UserDataClass: Codable {
    let userID, userFirstname, userLastname, userEmail: String
    let userPassword, userMobile, userCountry, userRoles: String
    let userCode, userVerified, createdAt, modifiedAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userFirstname = "user_firstname"
        case userLastname = "user_lastname"
        case userEmail = "user_email"
        case userPassword = "user_password"
        case userMobile = "user_mobile"
        case userCountry = "user_country"
        case userRoles = "user_roles"
        case userCode = "user_code"
        case userVerified = "user_verified"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }
}

