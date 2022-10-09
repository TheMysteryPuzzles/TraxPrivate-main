//
//  HomeSectionVoucherModel.swift
//  Trax
//
//  Created by mac on 29/09/2022.
//

import Foundation

// MARK: - HomeSectionVoucher
struct HomeSectionVoucher: Codable {
    let id, sectionID, vID: String

    enum CodingKeys: String, CodingKey {
        case id
        case sectionID = "section_id"
        case vID = "v_id"
    }
}

