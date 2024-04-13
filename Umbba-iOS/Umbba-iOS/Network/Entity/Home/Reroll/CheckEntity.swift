//
//  CheckEntity.swift
//  Umbba-iOS
//
//  Created by 최영린 on 4/4/24.
//

struct CheckEntity: Codable {
    let questionID: Int
    let newQuestion: String

    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case newQuestion = "new_question"
    }
}
