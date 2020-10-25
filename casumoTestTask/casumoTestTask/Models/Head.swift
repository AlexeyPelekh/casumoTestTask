//
//  Head.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Head {
    let label: String?
    let ref: String?
    let sha: String?
    let user: User?
    let repo: Repo?
}

// MARK: - Decodable
extension Head: Decodable {}
