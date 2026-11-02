//
//  DateExtensions.swift
//  Journal-Entry
//
//  Created by Deepak Ghadi on 02/11/26.
//

import Foundation

extension Date {
    /// Returns a formatted string for display in journal entries
    /// Example: "Nov 2, 2026"
    var journalDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    /// Returns a formatted time string
    /// Example: "2:30 PM"
    var journalTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    /// Returns a combined date and time string
    /// Example: "Nov 2, 2026 at 2:30 PM"
    var journalDateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    /// Returns a relative date string for recent entries
    /// Example: "Today", "Yesterday", "2 days ago"
    var relativeString: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if let daysAgo = calendar.dateComponents([.day], from: self, to: Date()).day,
                  daysAgo < 7 {
            return "\(daysAgo) days ago"
        } else {
            return journalDateString
        }
    }
    
    /// Returns true if the date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Returns true if the date is this week
    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Returns true if the date is this month
    var isThisMonth: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// Returns true if the date is this year
    var isThisYear: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}

// MARK: - Month Name Helper
extension Date {
    /// Returns the month name
    /// Example: "November"
    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    /// Returns the abbreviated month name
    /// Example: "Nov"
    var monthAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }
    
    /// Returns the day of month
    /// Example: 2
    var dayOfMonth: Int {
        Calendar.current.component(.day, from: self)
    }
    
    /// Returns the year
    /// Example: 2026
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}
