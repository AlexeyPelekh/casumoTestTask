//
//  Base.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Base: Decodable {
    let label: String?
    let ref: String?
    let sha: String?
    let user: User?
    let repo: Repo?
}
