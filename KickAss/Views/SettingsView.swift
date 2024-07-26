//
//  SettingsView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct SettingsView: View {

    var body: some View {

        ScrollView {
            VStack(spacing: 20) {
                HuntEditView()
                    .frame(height: 700)
                AppManagementView()
                    .frame(height: 700)
            }
        }
    }
}

#Preview {
    let huntInfoModel = HuntInfoModel()
    return SettingsView()
        .environment(huntInfoModel)

}
