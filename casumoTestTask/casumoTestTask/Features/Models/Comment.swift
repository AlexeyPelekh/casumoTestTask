//
//  Comment.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 26.10.2020.
//

import Foundation

struct Comment: Decodable {
    let url: String?
    let pull_request_review_id: Int?
    let id: Int?
    let node_id: String?
    let diff_hunk: String?
    let path: String?
    let position: Int?
    let original_position: Int?
    let commit_id: String?
    let original_commit_id: String?
    let user: User?
    let body: String?
    let created_at: String?
    let updated_at: String?
    let html_url: String?
    let pull_request_url: String?
    let author_association: String?
    let start_line: Int?
    let original_start_line: Int?
    let start_side: String?
    let line: Int?
    let original_line: Int?
    let side: String?
}
