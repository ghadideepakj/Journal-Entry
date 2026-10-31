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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Mood and Date
                HStack {
                    if isEditing {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Mood.allCases, id: \.self) { mood in
                                    MoodButton(
                                        mood: mood,
                                        isSelected: entry.mood == mood
                                    ) {
                                        entry.mood = mood
                                    }
                                }
                            }
                        }
                    } else {
                        Text(entry.mood.emoji)
                            .font(.system(size: 50))
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(entry.date, style: .date)
                                .font(.subheadline)
                            Text(entry.date, style: .time)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                if isEditing {
                    DatePicker("Date", selection: $entry.date, displayedComponents: [.date, .hourAndMinute])
                        .padding(.horizontal)
                }
                
                Divider()
                
                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    if isEditing {
                        TextField("Title", text: $entry.title)
                            .textFieldStyle(.roundedBorder)
                            .font(.title2.bold())
                    } else {
                        Text(entry.title)
                            .font(.title2.bold())
                    }
                }
                .padding(.horizontal)
                
                // Body
                VStack(alignment: .leading, spacing: 8) {
                    Text("Entry")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    if isEditing {
                        TextEditor(text: $entry.body)
                            .frame(minHeight: 300)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    } else {
                        Text(entry.body)
                            .font(.body)
                    }
                }
                .padding(.horizontal)
                
                if isEditing {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Entry", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(isEditing ? "Edit Entry" : "Journal Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
            
            if !isEditing {
                ToolbarItem(placement: .secondaryAction) {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
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
    }
    
    private func deleteEntry() {
        modelContext.delete(entry)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EntryDetailView(
            entry: JournalEntry(
                title: "My First Entry",
                body: "Today was a great day! I accomplished so much and felt really productive.",
                date: Date(),
                mood: .happy
            )
        )
    }
    .modelContainer(for: JournalEntry.self, inMemory: true)
}
