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

    @State var clueletter = "A"

    
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
                                .bold()
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        Spacer(minLength: 0)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .frame(width: 85, height: 600)
            .scrollContentBackground(.hidden)
            
        
    }
}


