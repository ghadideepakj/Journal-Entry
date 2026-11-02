//
//  ColorAssets.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 02/11/26.
//
//  This file documents the color assets that should be created in Assets.xcassets
//  for proper light/dark mode support

/*
 
 INSTRUCTIONS FOR SETTING UP COLOR ASSETS:
 
 1. Open Assets.xcassets in Xcode
 2. Click the + button at the bottom and select "New Color Set"
 3. Name it "AccentColor" (if not already present)
 4. Set the following values:
 
    AccentColor:
    - Any Appearance (Light): RGB (0, 122, 255) - iOS Blue
    - Dark Appearance: RGB (10, 132, 255) - Lighter Blue for dark mode
 
 5. The system colors used in Theme.swift automatically adapt to light/dark mode:
    - .systemBackground
    - .secondarySystemBackground  
    - .tertiarySystemBackground
    - .label
    - .secondaryLabel
 
 OPTIONAL: Create custom color sets for more control:
 
 CardBackground:
 - Light: RGB (255, 255, 255) - White
 - Dark: RGB (28, 28, 30) - Dark gray
 
 CardShadow:
 - Light: RGB (0, 0, 0) Alpha 0.1
 - Dark: RGB (0, 0, 0) Alpha 0.3
 
 These are currently using system colors but can be customized if desired.
 
 */

import SwiftUI

// This extension can be used if you want to add custom color assets
extension Color {
    // Example of how to add a custom color asset:
    // static let customAccent = Color("CustomAccent")
}
