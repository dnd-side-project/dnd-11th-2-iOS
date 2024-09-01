//
//  RUCalendarView.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct RUCalendarView: View {
    let store: StoreOf<RecordCalendarFeature>
    
    @State var month: Date = Date()
    @State var selectedDay: Int = 0
    @State var recordDay: Set<Int> = [2,9,19]
    
    var body: some View {
        VStack(spacing: 26) {
            headerView
            calendarGridView
        }
    }
}

extension RUCalendarView {
    private var headerView: some View {
            HStack {
                Button {
                    store.send(.tapLeftButton)
                } label: {
                    Image(.chevronLeft)
                        .resizable()
                        .frame(width: 11, height: 11)
                        .padding(10)
                }

                Text(store.currentMonth, formatter: DateFormatter.yyyyMM_kr)
                    .font(Fonts.pretendardSemiBold(size: 16))
                
                Button {
                    store.send(.tapRightButton)
                } label: {
                    Image(.chevronRight)
                        .resizable()
                        .frame(width: 11, height: 11)
                        .padding(10)
                }
            }.foregroundStyle(.white)
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: store.currentMonth)
        let firstWeekday: Int = firstWeekdayOfMonth(in: store.currentMonth) - 1
        
        return VStack {
            HStack {
                ForEach(getWeekdaySymbols(), id: \.self) { symbol in
                    Text(symbol)
                        .font(Fonts.pretendardSemiBold(size: 16))
                        .foregroundStyle(.gray300)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.clear)
                    } else {
                        let day = index - firstWeekday + 1
                        DayComponent(day: day, hasRecord: recordDay.contains(day))
                        .padding(.top, 13)
                        .onTapGesture {
                            if recordDay.contains(day) {
                                selectedDay = day
                            }
                        }
                    }
                }
            }
        }
    }
    
    private struct DayComponent: View {
        var day: Int
        var hasRecord: Bool
        
        var body: some View {
            ZStack {
                if hasRecord {
                    Circle()
                        .foregroundStyle(.mainGreen)
                        .frame(width: 24, height: 24)
                }
                
                Text(String(day))
                    .font(Fonts.pretendardRegular(size: 12))
                    .foregroundColor(hasRecord ? .mainDeepDark : .gray300)
                    .padding(.vertical, 5)
            }
        }
    }
    
}

extension RUCalendarView {
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

private extension RUCalendarView {
    
    private func getWeekdaySymbols() -> [String] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.veryShortWeekdaySymbols
    }
    
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
}


//#Preview {
//    RUCalendarView(selectedDay: .constant(0))
//}
