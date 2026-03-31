//
//  AppFont.swift
//  TeamUp
//
//  Created by Ilyes Mo on 28/03/2026.
//


import SwiftUI

extension Font {
    // Large titles - e.g. "Welcome Back", "Create Account"
    static let teamTitle = Font.custom("BebasNeue-Regular", size: 32)
    
    // Section headings
    static let teamHeading = Font.custom("BebasNeue-Regular", size: 24)
    
    // Buttons
    static let teamButton = Font.custom("BebasNeue-Regular", size: 20)
    
    // Body text - keep system font since Bebas has no regular weight
    static let teamBody = Font.system(size: 16)
    
    // Subtitles and hints
    static let teamSubtitle = Font.system(size: 14)
    
    // Small labels
    static let teamCaption = Font.system(size: 12)
}
