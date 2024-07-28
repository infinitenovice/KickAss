//
//  AppManagementView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct AppManagementView: View {
    @Environment (SiteMarkerModel.self) var siteMarkerModel
    @State var enableManagement: Bool = false

    var body: some View {
        Form {
            Section(header: Text("App Management")) {
                Toggle(isOn: $enableManagement) {
                    Text("Enable Management Functions")
                }

                if enableManagement {
                    Button {
                        siteMarkerModel.deleteAllMarkers()
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
let siteMarkerModel = SiteMarkerModel()
    return AppManagementView()
        .environment(siteMarkerModel)
}
