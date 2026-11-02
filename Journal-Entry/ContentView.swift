//
//  ContentView.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 29/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    @State private var showingNewEntry = false
    @State private var selectedEntry: JournalEntry?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                if entries.isEmpty {
                    emptyStateView
                } else {
                    entriesList
                }
            }
            .navigationTitle("My Journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        withAnimation(.theme.quick) {
                            showingNewEntry = true
                        }
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.body.weight(.medium))
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewEntryView()
                    .presentationBackground(.regularMaterial)
            }
        }
        .tint(.accentColor)
    }
    
    private var entriesList: some View {
        ScrollView {
            LazyVStack(spacing: .theme.sm) {
                ForEach(entries) { entry in
                    NavigationLink(value: entry) {
                        JournalEntryCard(entry: entry)
                    }
                    .buttonStyle(CardButtonStyle())
                }
            }
            .padding(.horizontal, .theme.md)
            .padding(.vertical, .theme.sm)
            .navigationDestination(for: JournalEntry.self) { entry in
                EntryDetailView(entry: entry)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: .theme.xl) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 80))
                .foregroundStyle(.secondary.opacity(0.5))
                .symbolEffect(.pulse.byLayer, options: .repeating)
            
            VStack(spacing: .theme.xs) {
                Text("Start Your Journey")
                    .font(.theme.title2)
                    .foregroundStyle(.primary)
                
                Text("Create your first journal entry and capture\nthe moments that matter")
                    .font(.theme.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation(.theme.quick) {
                    showingNewEntry = true
                }
            } label: {
                Label("New Entry", systemImage: "square.and.pencil")
                    .font(.theme.bodyEmphasized)
                    .padding(.horizontal, .theme.xl)
                    .padding(.vertical, .theme.sm)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .padding(.theme.xl)
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    @State private var isPressed = false
    
    var body: some View {
        HStack(alignment: .top, spacing: .theme.md) {
            // Mood Indicator
            ZStack {
                Circle()
                    .fill(Color.theme.moodColor(for: entry.mood))
                    .frame(width: 56, height: 56)
                
                Text(entry.mood.emoji)
                    .font(.system(size: 32))
            }
            .shadow(color: Color.theme.moodAccentColor(for: entry.mood).opacity(0.3),
                    radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: .theme.xxs) {
                Text(entry.title)
                    .font(.theme.entryTitle)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text(entry.body)
                    .font(.theme.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.top, 2)
                
                HStack(spacing: .theme.xs) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    
                    Text(entry.date, format: .dateTime.month(.abbreviated).day().year())
                        .font(.theme.caption)
                    
                    Text("•")
                        .font(.caption2)
                    
                    Text(entry.date, format: .dateTime.hour().minute())
                        .font(.theme.caption)
                }
                .foregroundStyle(.tertiary)
                .padding(.top, .theme.xxs)
            }
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.theme.md)
        .background(
            RoundedRectangle(cornerRadius: .cornerRadius.medium)
                .fill(Color.theme.cardBackground)
                .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.theme.quick, value: isPressed)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.theme.quick, value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
