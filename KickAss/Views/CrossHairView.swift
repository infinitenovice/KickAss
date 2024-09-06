//
//  CrossHairView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct CrossHairView: View {
    var body: some View {
        ZStack {
            Image(systemName: "dot.scope")
        }
        .font(.system(size: 26))
        .foregroundColor(.red)
    }//body
}//View

#Preview {
    CrossHairView()
}
