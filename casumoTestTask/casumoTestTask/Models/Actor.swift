//
//  Actor.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Actor {
    let id: Int?
    let login: String?
    let display_login: String?
    let gravatar_id: String?
    let url: String?
    let avatar_url: String?
}

// MARK: - Decodable
extension Actor: Decodable {}
