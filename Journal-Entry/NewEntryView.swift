//
//  NewEntryView.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 29/10/26.
//

import SwiftUI
import SwiftData

struct NewEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood: Mood = .happy
    @State private var selectedDate = Date()
    @FocusState private var focusedField: Field?
    @State private var showSuccessAnimation = false
    
    enum Field {
        case title, content
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: .theme.xl) {
                        // Mood Section
                        VStack(alignment: .leading, spacing: .theme.md) {
                            Text("How are you feeling?")
                                .font(.theme.headline)
                                .foregroundStyle(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: .theme.md) {
                                    ForEach(Mood.allCases, id: \.self) { mood in
                                        MoodButton(
                                            mood: mood,
                                            isSelected: selectedMood == mood
                                        ) {
                                            withAnimation(.theme.standard) {
                                                selectedMood = mood
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, .theme.xxs)
                            }
                        }
                        .padding(.horizontal, .theme.md)
                        
                        // Date Section
                        VStack(spacing: .theme.sm) {
                            HStack {
                                Label("Date & Time", systemImage: "calendar")
                                    .font(.theme.headline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .tint(.accentColor)
                        }
                        .padding(.theme.md)
                        .background(
                            RoundedRectangle(cornerRadius: .cornerRadius.medium)
                                .fill(Color.theme.secondaryBackground)
                        )
                        .padding(.horizontal, .theme.md)
                        
                        // Title Section
                        VStack(alignment: .leading, spacing: .theme.sm) {
                            Text("Title")
                                .font(.theme.headline)
                                .foregroundStyle(.secondary)
                            
                            TextField("Give your entry a title...", text: $title, axis: .vertical)
                                .font(.theme.entryTitle)
                                .padding(.theme.sm)
                                .background(
                                    RoundedRectangle(cornerRadius: .cornerRadius.small)
                                        .fill(Color.theme.secondaryBackground)
                                )
                                .focused($focusedField, equals: .title)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .content
                                }
                        }
                        .padding(.horizontal, .theme.md)
                        
                        // Content Section
                        VStack(alignment: .leading, spacing: .theme.sm) {
                            Text("Your thoughts")
                                .font(.theme.headline)
                                .foregroundStyle(.secondary)
                            
                            ZStack(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("What's on your mind today?")
                                        .font(.theme.entryBody)
                                        .foregroundStyle(.tertiary)
                                        .padding(.theme.sm)
                                        .padding(.top, 8)
                                }
                                
                                TextEditor(text: $content)
                                    .font(.theme.entryBody)
                                    .frame(minHeight: 250)
                                    .padding(.theme.xxs)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .focused($focusedField, equals: .content)
                            }
                            .padding(.theme.xxs)
                            .background(
                                RoundedRectangle(cornerRadius: .cornerRadius.small)
                                    .fill(Color.theme.secondaryBackground)
                            )
                        }
                        .padding(.horizontal, .theme.md)
                        
                        Spacer(minLength: .theme.xl)
                    }
                    .padding(.vertical, .theme.lg)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        withAnimation(.theme.quick) {
                            dismiss()
                        }
                    }
                    .tint(.secondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveEntry()
                    } label: {
                        Text("Save")
                            .font(.theme.bodyEmphasized)
                    }
                    .disabled(title.isEmpty)
                    .tint(.accentColor)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    focusedField = .title
                }
            }
        }
    }
    
    private func saveEntry() {
        let newEntry = JournalEntry(
            title: title,
            body: content,
            date: selectedDate,
            mood: selectedMood
        )
        
        withAnimation(.theme.standard) {
            modelContext.insert(newEntry)
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            VStack(spacing: .theme.xxs) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.theme.moodColor(for: mood) : Color.theme.tertiaryBackground)
                        .frame(width: 64, height: 64)
                    
                    if isSelected {
                        Circle()
                            .stroke(Color.theme.moodAccentColor(for: mood), lineWidth: 3)
                            .frame(width: 64, height: 64)
                    }
                    
                    Text(mood.emoji)
                        .font(.system(size: 32))
                }
                .shadow(
                    color: isSelected ? Color.theme.moodAccentColor(for: mood).opacity(0.4) : .clear,
                    radius: 8,
                    x: 0,
                    y: 4
                )
                
                Text(moodName(for: mood))
                    .font(.caption2.weight(isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.theme.standard, value: isSelected)
    }
    
    private func moodName(for mood: Mood) -> String {
        switch mood {
        case .happy: return "Happy"
        case .excited: return "Excited"
        case .calm: return "Calm"
        case .sad: return "Sad"
        case .angry: return "Angry"
        case .tired: return "Tired"
        case .loving: return "Loving"
        case .thoughtful: return "Thoughtful"
        }
    }
}

#Preview {
    NewEntryView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
