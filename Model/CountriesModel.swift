//
//  CountriesModel.swift
//  Trax
//
//  Created by mac on 16/09/2022.
//

import Foundation

// MARK: - Countries
struct Countries: Codable {
    let data: [CountryDatum]
}

// MARK: - Datum
struct CountryDatum: Codable {
    let id, iso, name, nicename: String
    let phonecode: String
}

