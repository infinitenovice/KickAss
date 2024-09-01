//
//  HuntEditView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct HuntEditView: View {
    @Environment(HuntInfoModel.self) var huntInfoModel
    @State var dateSelection = Date.now

    var body: some View {
        @Bindable var huntInfoModel = huntInfoModel
        
        Form {
            Section(header: Text("Hunt Information")) {
                DatePicker(selection: $huntInfoModel.huntInfo.huntStartDate, label: { Text("Hunt Date") })
                TextField("Hunt Name", text: $huntInfoModel.huntInfo.huntTitle)
                TextField("Hunt Theme", text: $huntInfoModel.huntInfo.huntTheme)
                TextField("Car Number", text: $huntInfoModel.huntInfo.carNumber)
                TextField("Team Name", text: $huntInfoModel.huntInfo.teamName)
            }
            Section(header: Text("Team Member Distribution List")) {
                ForEach($huntInfoModel.huntInfo.teamMembers) { $member in
                    HStack {
                        TextField("Name", text: $member.name)
                            .frame(width: 100)
                        TextField("Phone Number", text: $member.phoneNumber)
                        Toggle(isOn: $member.iPhone) {
                            Text("iPhone")
                                .font(.title3)
                        }
                        .frame(width: 120)
                        .padding(.trailing)
                        Toggle(isOn: $member.enable) {
                            Text("Enable")
                                .font(.title3)
                        }
                        .frame(width: 120)
                    }
                }
            }
        }
        .font(.title2)
        .padding()
    }
    
}

#Preview {
    let huntInfoModel = HuntInfoModel()
    return HuntEditView()
        .environment(huntInfoModel)
}
