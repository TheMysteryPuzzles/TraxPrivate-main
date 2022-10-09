//
//  HomeSectionModel.swift
//  Trax
//
//  Created by mac on 29/09/2022.
//

import Foundation

// MARK: - HomeSection
struct HomeSection: Codable {
    let sectionID, sectionTitle, sectionSerial, sectionDescription, sectionType: String

    enum CodingKeys: String, CodingKey {
        case sectionID = "section_id"
        case sectionSerial = "section_serial"
        case sectionTitle = "section_title"
        case sectionDescription = "section_description"
        case sectionType = "section_type"
    }
}

