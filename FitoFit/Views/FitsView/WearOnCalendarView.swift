
//
//  WearOnCalendarView.swift
//  FitoFit
//


import SwiftUI

struct WearOnCalendarView: View {
    let outfit: Outfit
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDates: Set<Date> = []
    @EnvironmentObject var calendarViewModel: CalendarViewModel

    private let calendar = Calendar.current
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date())
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date())

    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var onComplete: (() -> Void)?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text("\(months[currentMonth - 1]) \(currentYear)")
                        .font(.headline)
                    Spacer()
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)

                HStack {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(generateMonthDays(), id: \.self) { date in
                            if let date = date {
                                Text("\(calendar.component(.day, from: date))")
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedDates.contains(date) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        toggleDateSelection(date)
                                    }
                            } else {
                                Color.clear.frame(height: 40)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: saveSelectedDates) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Select Dates")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func toggleDateSelection(_ date: Date) {
        if selectedDates.contains(date) {
            selectedDates.remove(date)
        } else {
            selectedDates.insert(date)
        }
    }

    private func saveSelectedDates() {
        for date in selectedDates {
            calendarViewModel.addOutfit(outfit, to: date)
        }
        onComplete?()
        dismiss()
    }

    private func generateMonthDays() -> [Date?] {
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else {
            return []
        }

        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        days += range.map { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
        return days
    }

    private func changeMonth(by value: Int) {
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
