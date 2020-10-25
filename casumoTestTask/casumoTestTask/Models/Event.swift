//
//  Event.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Event {
    let id: String?
    let type: String?
    let actor: Actor?
    let repo: Repo?
    let payload: Payload?
    let isPublic: Bool?
    let created_at: String?
}

// MARK: - Decodable
extension Event: Decodable {}
