//
//  ToggleStyle.swift
//  KickAss
//
//  Created by Infinite Novice on 9/4/24.
//

import SwiftUI

struct ToggleCheckBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            if configuration.isOn {
                Image(systemName: "checkmark.square")
            } else {
                Image(systemName: "square")
            }
            configuration.label
        }
        .tint(.primary)
    }
}

extension ToggleStyle where Self == ToggleCheckBoxStyle {
    static var checkboxIOS: ToggleCheckBoxStyle { .init() }
}
