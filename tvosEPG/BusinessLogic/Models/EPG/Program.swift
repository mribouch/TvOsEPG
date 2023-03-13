//
//  Program.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import Foundation

struct Program: Codable, Identifiable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    
//    let startDate: Int
//    let endDate: Int
    var duration: Int {
        let interval = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        return Int(interval)
    }
    
    var startMinuteSinceMidnight: Int {
        let interval = startDate.timeIntervalSince1970 - Date.now.midnight.timeIntervalSince1970
        return Int.secondsToMinutes(sec: Int(interval))
    }
    
    enum Keys: CodingKey {
        case id
        case title
        case startDate
        case endDate
    }
}

extension Program {
    
    func programHasBegun() -> Bool {
        (startDate...endDate).contains(Date.now)
    }
    
}
