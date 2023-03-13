//
//  Channel.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import Foundation

struct Channel: Codable, Identifiable {
    let id: UUID
    let title: String
    let number: Int
    let programs: [Program]
}
