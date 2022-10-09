//
//  CategoryModel.swift
//  Trax
//
//  Created by mac on 25/08/2022.

//   let category = try? newJSONDecoder().decode(Category.self, from: jsonData)

import Foundation

// MARK: - Category
struct Category: Codable {
    let catID, catName, catImage, catDesc: String
    let catStatus, createdAt, updatedAt: String
    let deletedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case catID = "cat_id"
        case catName = "cat_name"
        case catImage = "cat_image"
        case catDesc = "cat_desc"
        case catStatus = "cat_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

