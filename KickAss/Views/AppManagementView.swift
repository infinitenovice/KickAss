//
//  AppManagementView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct AppManagementView: View {
    @State var enableManagement: Bool = false

    var body: some View {
        Form {
            Section(header: Text("App Management")) {
                Toggle(isOn: $enableManagement) {
                    Text("Enable Management Functions")
                }

                if enableManagement {
                    Button {

                    } label: {
                        Text("Clear all site markers")
                    }
                }
            }
        }
        .font(.title)
        .padding()
    }
}

#Preview {

    return AppManagementView()

}
