//
//  EPGConfigurator.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import Foundation

final class EPGConfigurator {
    static func configureEPGView(with viewModel: EPGViewModel = EPGViewModel()) -> EPGView {
        let epgView = EPGView(viewModel: viewModel)
        return epgView
    }
}
