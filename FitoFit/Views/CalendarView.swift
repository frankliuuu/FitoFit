//
//  CalendarView.swift
//  FitoFit
//
//  Created by Frank Liu on 10/30/24.
//

import SwiftUI


import SwiftUI

struct CalendarView: View {
    // State variables to track the selected month and year
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date())
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date())

    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var body: some View {
        VStack {
            // Header Section with Profile Icon and Title
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("Your Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // Month and Year Selector Section
            HStack {
                // Left Arrow to Decrease Month
                Button(action: {
                    changeMonth(by: -1) // Move to the previous month
                }) {
                    Image(systemName: "chevron.left")
                }

                // Current Month and Year Display (Centered)
                Spacer()
                Text("\(months[currentMonth - 1]) \(currentYear)")
                    .font(.headline)
                Spacer()

                // Right Arrow to Increase Month
                Button(action: {
                    changeMonth(by: 1) // Move to the next month
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)

            // Day Labels (Sun, Mon, ...)
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // Calendar Grid for Days of the Month
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(generateMonthDays(), id: \.self) { day in
                        Text(day == 0 ? "" : "\(day)")
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(day == 0 ? Color.clear : Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
                .padding(.horizontal)
            }

        }
    }

    // Helper function to generate the days of the current month
    func generateMonthDays() -> [Int] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        guard let firstDayOfMonth = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        // Create array with empty days until the first weekday, followed by the days of the month
        let emptyDays = Array(repeating: 0, count: firstWeekday - 1)
        let days = range.map { $0 }
        return emptyDays + days
    }

    // Helper function to change the month, with year rollover
    func changeMonth(by value: Int) {
        currentMonth += value

        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        } else if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
    }
}


#Preview {
    CalendarView()
}
