//
//  ProgramModifier.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import Foundation
import SwiftUI

struct ProgramModifier: ViewModifier {
    @FocusState var isFocused
    var hasBegun: Bool
    
    func body(content: Content) -> some View {
        content
            .focusable()
            .focused($isFocused)
            .background(isFocused ? RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 3).background(.orange) :
                            hasBegun ? RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 3).background(.gray) :
                            RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 3).background(.clear))
            .animation(.easeIn(duration: 0.2), value: isFocused)
    }
}
