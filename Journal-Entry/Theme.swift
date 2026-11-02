//
//  Theme.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 02/11/26.
//

import SwiftUI

// MARK: - Color Theme
extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Primary Colors
    let accent = Color("AccentColor")
    let primary = Color.primary
    let secondary = Color.secondary
    
    // Background Colors
    let background = Color(uiColor: .systemBackground)
    let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)
    
    // Card Colors
    let cardBackground = Color(uiColor: .systemBackground)
    let cardShadow = Color.black.opacity(0.1)
    
    // Mood Colors
    func moodColor(for mood: Mood) -> Color {
        switch mood {
        case .happy: return Color.yellow.opacity(0.2)
        case .excited: return Color.orange.opacity(0.2)
        case .calm: return Color.blue.opacity(0.2)
        case .sad: return Color.blue.opacity(0.3)
        case .angry: return Color.red.opacity(0.2)
        case .tired: return Color.purple.opacity(0.2)
        case .loving: return Color.pink.opacity(0.2)
        case .thoughtful: return Color.indigo.opacity(0.2)
        }
    }
    
    func moodAccentColor(for mood: Mood) -> Color {
        switch mood {
        case .happy: return Color.yellow
        case .excited: return Color.orange
        case .calm: return Color.blue
        case .sad: return Color.blue.opacity(0.7)
        case .angry: return Color.red
        case .tired: return Color.purple
        case .loving: return Color.pink
        case .thoughtful: return Color.indigo
        }
    }
}

// MARK: - Typography
extension Font {
    static let theme = FontTheme()
}

struct FontTheme {
    // Navigation
    let largeTitle = Font.largeTitle.weight(.bold)
    let title = Font.title.weight(.semibold)
    let title2 = Font.title2.weight(.semibold)
    let title3 = Font.title3.weight(.semibold)
    
    // Body
    let body = Font.body
    let bodyEmphasized = Font.body.weight(.medium)
    let callout = Font.callout
    
    // Supporting
    let headline = Font.headline
    let subheadline = Font.subheadline
    let caption = Font.caption
    let caption2 = Font.caption2
    
    // Entry
    let entryTitle = Font.system(size: 22, weight: .semibold)
    let entryBody = Font.system(size: 16, weight: .regular)
    let entryDate = Font.system(size: 14, weight: .regular)
}

// MARK: - Spacing
extension CGFloat {
    static let theme = SpacingTheme()
}

struct SpacingTheme {
    let xxs: CGFloat = 4
    let xs: CGFloat = 8
    let sm: CGFloat = 12
    let md: CGFloat = 16
    let lg: CGFloat = 20
    let xl: CGFloat = 24
    let xxl: CGFloat = 32
}

// MARK: - Animation
extension Animation {
    static let theme = AnimationTheme()
}

struct AnimationTheme {
    let standard = Animation.spring(response: 0.35, dampingFraction: 0.8)
    let quick = Animation.spring(response: 0.25, dampingFraction: 0.85)
    let smooth = Animation.easeInOut(duration: 0.3)
    let gentle = Animation.easeOut(duration: 0.4)
}

// MARK: - Corner Radius
extension CGFloat {
    static let cornerRadius = CornerRadiusTheme()
}

struct CornerRadiusTheme {
    let small: CGFloat = 8
    let medium: CGFloat = 12
    let large: CGFloat = 16
    let xlarge: CGFloat = 20
}
