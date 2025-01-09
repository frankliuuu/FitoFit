//
//  CalendarView.swift
//  FitoFit
//

import SwiftUI

struct CalendarView: View {
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date())
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDate: Date? = nil
    @State private var selectedOutfit: Outfit? = nil
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel

    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var body: some View {
        VStack {
            
            HStack {
                ProfilePictureView()
                    .environmentObject(profileViewModel)
                Text("Your Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("\(months[currentMonth - 1]) \(formatYear(currentYear))")
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

            // Calendar Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(generateMonthDays(), id: \.self) { date in
                        if let date = date {
                            Text("\(Calendar.current.component(.day, from: date))")
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .background(dateHasOutfit(date) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .cornerRadius(5)
                                .onTapGesture {
                                    selectedDate = date
                                }
                        } else {
                            Color.clear.frame(height: 40)
                        }
                    }
                }
                .padding(.horizontal)
            }

            if let selectedDate = selectedDate {
                let formattedDate = formatDate(selectedDate)
                Text("Your outfits for \(formattedDate)")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                let outfits = calendarViewModel.outfits(for: selectedDate)
                if outfits.isEmpty {
                    Text("No outfits planned for this day.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(outfits) { outfit in
                                OutfitThumbnailView(outfit: outfit)
                                    .frame(height: 300)
                                    .onTapGesture {
                                        selectedOutfit = outfit
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(item: $selectedOutfit) { outfit in
            DayOutfitDetailView(outfit: outfit, selectedDate: selectedDate!)
                .environmentObject(calendarViewModel)
        }
    }
    
    func formatYear(_ year: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none // Plain number formatting
        return formatter.string(from: NSNumber(value: year)) ?? "\(year)"
    }

    private func generateMonthDays() -> [Date?] {
        let calendar = Calendar.current
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

    private func dateHasOutfit(_ date: Date) -> Bool {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        return !(calendarViewModel.plannedOutfits[normalizedDate]?.isEmpty ?? true)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}


#Preview {
    CalendarView()
        .environmentObject(ClosetViewModel())
        .environmentObject(ProfileViewModel())
        .environmentObject(CalendarViewModel())
}
