//
//  Commit.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Commit: Decodable {
    let sha: String?
    let author: Author?
    let message: String?
    let isDistinct: Bool?
    let url: String?
}
