//
//  Color.swift
//  KickAss
//
//  Created by Infinite Novice on 9/4/24.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let secondarytext = Color("SecondaryTextColor")
    let secondarybackground = Color("SecondaryBackgroundColor")
    let emergency = Color("SiteEmergencyColor")
    let found = Color("SiteFoundColor")
    let jackass = Color("SiteJackassColor")
    let potentialsite = Color("SitePotentialColor")
    let requiredsite = Color("SiteRequiredColor")
}
