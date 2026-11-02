//
//  ViewModifiers.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 02/11/26.
//

import SwiftUI

// MARK: - Card Modifier
struct CardModifier: ViewModifier {
    var cornerRadius: CGFloat = .cornerRadius.medium
    var shadowRadius: CGFloat = 8
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.cardShadow, radius: shadowRadius, x: 0, y: 2)
            )
    }
}

// MARK: - Input Field Modifier
struct InputFieldModifier: ViewModifier {
    var cornerRadius: CGFloat = .cornerRadius.small
    
    func body(content: Content) -> some View {
        content
            .padding(.theme.sm)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.theme.secondaryBackground)
            )
    }
}

// MARK: - Section Header Modifier
struct SectionHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }
}

// MARK: - Pressable Scale Modifier
struct PressableScaleModifier: ViewModifier {
    @State private var isPressed = false
    let scale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.theme.quick, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

// MARK: - View Extensions
extension View {
    /// Applies a card style with background and shadow
    func cardStyle(cornerRadius: CGFloat = .cornerRadius.medium, shadowRadius: CGFloat = 8) -> some View {
        modifier(CardModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
    
    /// Applies an input field style
    func inputFieldStyle(cornerRadius: CGFloat = .cornerRadius.small) -> some View {
        modifier(InputFieldModifier(cornerRadius: cornerRadius))
    }
    
    /// Applies a section header style
    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderModifier())
    }
    
    /// Adds a pressable scale effect
    func pressableScale(_ scale: CGFloat = 0.97) -> some View {
        modifier(PressableScaleModifier(scale: scale))
    }
}

// MARK: - Shape Extensions
extension Shape {
    /// Fills the shape with a mood color
    func fillWithMoodColor(_ mood: Mood) -> some View {
        self.fill(Color.theme.moodColor(for: mood))
    }
    
    /// Strokes the shape with a mood accent color
    func strokeWithMoodAccent(_ mood: Mood, lineWidth: CGFloat = 2) -> some View {
        self.stroke(Color.theme.moodAccentColor(for: mood), lineWidth: lineWidth)
    }
}

// MARK: - Text Extensions
extension Text {
    /// Applies entry title styling
    func entryTitleStyle() -> some View {
        self
            .font(.theme.entryTitle)
            .foregroundStyle(.primary)
    }
    
    /// Applies entry body styling
    func entryBodyStyle() -> some View {
        self
            .font(.theme.entryBody)
            .foregroundStyle(.primary)
            .lineSpacing(6)
    }
    
    /// Applies date styling
    func dateStyle() -> some View {
        self
            .font(.theme.caption)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Haptic Feedback Helper
enum HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
