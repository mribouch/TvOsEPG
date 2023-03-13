//
//  Extension+Date.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 11/03/2023.
//

import Foundation

extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium,
      timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(
          from: self,
          dateStyle: dateStyle,
          timeStyle: timeStyle)
    }

    var midnight: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
}
