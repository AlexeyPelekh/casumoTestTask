//
//  Payload.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Payload: Decodable {
    let action: String?
    let push_id: Int?
    let size: Int?
    let distinct_size: Int?
    let ref: String?
    let head: String?
    let before: String?
    let comits: [Commit]?
//    let pull_request: PullRequest?
    let comment: Comment?
}
