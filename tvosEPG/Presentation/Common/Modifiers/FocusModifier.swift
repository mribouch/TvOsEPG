//
//  FocusModifier.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import Foundation
import SwiftUI

struct FocusModifier: ViewModifier {
    @FocusState var isFocused
    
    func body(content: Content) -> some View {
        content
            .focusable()
            .focused($isFocused)
            .scaleEffect(isFocused ? 1.3 : 1)
            .animation(.easeIn(duration: 0.2), value: isFocused)
    }
    
}
