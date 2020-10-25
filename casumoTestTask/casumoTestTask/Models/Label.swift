//
//  Label.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Label {
    let id: Int?
    let node_id: String?
    let url: String?
    let name: String?
    let color: String?
    let isDefault: Bool?
    let description: String?
}

// MARK: - Decodable
extension Label: Decodable {}
