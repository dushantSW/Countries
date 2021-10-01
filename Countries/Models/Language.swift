//
//  Language.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation

struct Language: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case code = "iso639_2"
    }
    
    let name: String
    let code: String
}
