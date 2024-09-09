//
//  SitePickerView.swift
//  KickAss
//
//  Created by Infinite Novice on 9/4/24.
//

import SwiftUI

struct SitePickerView: View {
    var markerIndex: Int
    @Binding var pickedItem: String
    @Binding var isShowing: Bool

    @Environment(MarkerModel.self) var markerModel


    
    var body: some View {

        Form {
            ForEach(markerModel.ClueLetterMonograms, id: \.self) {item in
                HStack{
                    Spacer(minLength: 0)
                    Button {
                        pickedItem = item
                        isShowing = false
                    } label: {
                        Text("\(item)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.theme.textPrimary)
                    }
                    Spacer(minLength: 0)
                }
            }
            .listRowSeparator(.hidden)
        }
        .frame(width: 85, height: 600)
        .background(Color.theme.backgroundTertiary)
        .scrollContentBackground(.hidden)
    }
}


