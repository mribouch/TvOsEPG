//
//  tvosEPGApp.swift
//  tvosEPG
//
//  Created by Martin Ribouchon on 08/03/2023.
//

import SwiftUI

@main
struct tvosEPGApp: App {
    var body: some Scene {
        WindowGroup {
            EPGConfigurator.configureEPGView()
        }
    }
}
