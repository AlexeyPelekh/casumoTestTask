//
//  Author.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Author {
    let email: String?
    let name: String?
}

// MARK: - Decodable
extension Author: Decodable {}
