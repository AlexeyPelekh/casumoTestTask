//
//  Payload.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Payload {
    let push_id: Int?
    let size: Int?
    let distinct_size: Int?
    let ref: String?
    let head: String?
    let before: String?
    let comits: [Commit]?
    let pull_request: PullRequest?
}

// MARK: - Decodable
extension Payload: Decodable {}
