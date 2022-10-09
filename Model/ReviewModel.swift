//
//  ReviewModel.swift
//  Trax
//
//  Created by mac on 16/09/2022.
//

import Foundation

// MARK: - Review
struct Review: Codable {
    let reviewID, vID, name, rating: String
    let review, createdAt: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case vID = "v_id"
        case name, rating, review
        case createdAt = "created_at"
    }
}

