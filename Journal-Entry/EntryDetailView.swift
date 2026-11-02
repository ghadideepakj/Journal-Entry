//
//  EntryDetailView.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 29/10/26.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var entry: JournalEntry
    
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    @State private var editedTitle = ""
    @State private var editedBody = ""
    @State private var editedMood: Mood = .happy
    @State private var editedDate = Date()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, body
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section with Mood & Date
                    headerSection
                        .padding(.horizontal, .theme.md)
                        .padding(.top, .theme.lg)
                        .padding(.bottom, .theme.xl)
                    
                    // Content Section
                    VStack(alignment: .leading, spacing: .theme.xl) {
                        if isEditing {
                            editingView
                        } else {
                            readOnlyView
                        }
                    }
                    .padding(.horizontal, .theme.md)
                    .padding(.bottom, .theme.xxl)
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    toggleEditMode()
                } label: {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.theme.bodyEmphasized)
                }
                .tint(.accentColor)
            }
            
            if !isEditing {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete Entry", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
        } message: {
            Text("Are you sure you want to delete this journal entry? This action cannot be undone.")
        }
        .onAppear {
            setupEditingState()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(alignment: .center, spacing: .theme.md) {
            if isEditing {
                // Mood Selector in Edit Mode
                Menu {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        Button {
                            withAnimation(.theme.standard) {
                                editedMood = mood
                            }
                        } label: {
                            HStack {
                                Text(mood.emoji)
                                Text(moodName(for: mood))
                                if editedMood == mood {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.theme.moodColor(for: editedMood))
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .stroke(Color.theme.moodAccentColor(for: editedMood), lineWidth: 3)
                            .frame(width: 80, height: 80)
                        
                        Text(editedMood.emoji)
                            .font(.system(size: 44))
                    }
                    .shadow(color: Color.theme.moodAccentColor(for: editedMood).opacity(0.4),
                            radius: 12, x: 0, y: 6)
                }
            } else {
                // Read-only Mood Display
                ZStack {
                    Circle()
                        .fill(Color.theme.moodColor(for: entry.mood))
                        .frame(width: 80, height: 80)
                    
                    Text(entry.mood.emoji)
                        .font(.system(size: 44))
                }
                .shadow(color: Color.theme.moodAccentColor(for: entry.mood).opacity(0.3),
                        radius: 12, x: 0, y: 6)
            }
            
            Spacer()
            
            // Date Display
            VStack(alignment: .trailing, spacing: .theme.xxs) {
                if isEditing {
                    DatePicker(
                        "",
                        selection: $editedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .labelsHidden()
                    .tint(.accentColor)
                } else {
                    Text(entry.date, format: .dateTime.month(.abbreviated).day().year())
                        .font(.theme.headline)
                        .foregroundStyle(.primary)
                    
                    Text(entry.date, format: .dateTime.hour().minute())
                        .font(.theme.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(moodName(for: entry.mood))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.theme.moodAccentColor(for: entry.mood))
                        .padding(.horizontal, .theme.xs)
                        .padding(.vertical, .theme.xxs)
                        .background(
                            Capsule()
                                .fill(Color.theme.moodColor(for: entry.mood))
                        )
                }
            }
        }
    }
    
    // MARK: - Read Only View
    private var readOnlyView: some View {
        VStack(alignment: .leading, spacing: .theme.xl) {
            // Title
            Text(entry.title)
                .font(.system(size: 28, weight: .bold, design: .default))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            // Body
            Text(entry.body)
                .font(.theme.entryBody)
                .foregroundStyle(.primary)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.98)))
    }
    
    // MARK: - Editing View
    private var editingView: some View {
        VStack(alignment: .leading, spacing: .theme.lg) {
            // Title Editor
            VStack(alignment: .leading, spacing: .theme.sm) {
                Text("TITLE")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                TextField("Entry title", text: $editedTitle, axis: .vertical)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .padding(.theme.sm)
                    .background(
                        RoundedRectangle(cornerRadius: .cornerRadius.small)
                            .fill(Color.theme.secondaryBackground)
                    )
                    .focused($focusedField, equals: .title)
            }
            
            // Body Editor
            VStack(alignment: .leading, spacing: .theme.sm) {
                Text("THOUGHTS")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                ZStack(alignment: .topLeading) {
                    if editedBody.isEmpty {
                        Text("Your thoughts...")
                            .font(.theme.entryBody)
                            .foregroundStyle(.tertiary)
                            .padding(.theme.sm)
                            .padding(.top, 8)
                    }
                    
                    TextEditor(text: $editedBody)
                        .font(.theme.entryBody)
                        .lineSpacing(6)
                        .frame(minHeight: 300)
                        .padding(.theme.xxs)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .focused($focusedField, equals: .body)
                }
                .padding(.theme.xxs)
                .background(
                    RoundedRectangle(cornerRadius: .cornerRadius.small)
                        .fill(Color.theme.secondaryBackground)
                )
            }
            
            // Delete Button
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Entry")
                }
                .font(.theme.bodyEmphasized)
                .frame(maxWidth: .infinity)
                .padding(.vertical, .theme.sm)
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.98)))
    }
    
    // MARK: - Helper Methods
    private func setupEditingState() {
        editedTitle = entry.title
        editedBody = entry.body
        editedMood = entry.mood
        editedDate = entry.date
    }
    
    private func toggleEditMode() {
        if isEditing {
            // Save changes
            withAnimation(.theme.standard) {
                entry.title = editedTitle
                entry.body = editedBody
                entry.mood = editedMood
                entry.date = editedDate
            }
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            // Enter edit mode
            setupEditingState()
        }
        
        withAnimation(.theme.standard) {
            isEditing.toggle()
        }
        
        focusedField = nil
    }
    
    private func deleteEntry() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        withAnimation(.theme.standard) {
            modelContext.delete(entry)
        }
        
        dismiss()
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
    NavigationStack {
        EntryDetailView(
            entry: JournalEntry(
                title: "My First Entry",
                body: "Today was a great day! I accomplished so much and felt really productive. The weather was beautiful, and I spent some time outside enjoying nature. I'm grateful for all the opportunities that came my way today.",
                date: Date(),
                mood: .happy
            )
        )
    }
    .modelContainer(for: JournalEntry.self, inMemory: true)
}
