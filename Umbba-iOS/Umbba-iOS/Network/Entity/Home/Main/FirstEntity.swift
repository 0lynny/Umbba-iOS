//
//  FirstEntity.swift
//  Umbba-iOS
//
//  Created by 고아라 on 4/10/24.
//

import Foundation

struct FirstEntity: Codable {
    let isFirstEntry: Bool

    enum CodingKeys: String, CodingKey {
        case isFirstEntry = "is_first_entry"
    }
}
