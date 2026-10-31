//
//  JournalEntry.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 29/10/26.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var title: String
    var body: String
    var date: Date
    var mood: Mood
    
    init(title: String, body: String, date: Date, mood: Mood) {
        self.title = title
        self.body = body
        self.date = date
        self.mood = mood
    }
}

enum Mood: String, Codable, CaseIterable {
    case happy = "😊"
    case excited = "🤩"
    case calm = "😌"
    case sad = "😢"
    case angry = "😠"
    case tired = "😴"
    case loving = "🥰"
    case thoughtful = "🤔"
    
    var emoji: String {
        return self.rawValue
    }
}
