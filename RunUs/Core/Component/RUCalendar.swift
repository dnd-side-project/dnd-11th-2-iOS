//
//  RUCalendar.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct RUCalendar: View {
    @State var store: StoreOf<RunningRecordStore>
    
    var body: some View {
        VStack(spacing: 26) {
            headerView
            calendarGridView
        }
    }
}

extension RUCalendar {
    private var headerView: some View {
        HStack(spacing: 6) {
            Button {
                store.send(.tapLeftButton)
            } label: {
                Image(.chevronLeft)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
            }

            Text(store.currentMonth, formatter: DateFormatter.yyyyMM_kr)
                .font(Fonts.pretendardSemiBold(size: 16))
                .padding(.bottom, 3)    // MARK: 양 이미지들과 높이를 맞추기 위한 임시 처리
            
            Button {
                store.send(.tapRightButton)
            } label: {
                Image(.chevronRight)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
            }
        }
        .foregroundStyle(.white)
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
                        DayComponent(day: day, hasRecord: store.recordDays.contains(day))
                            .padding(.top, 13)
                            .onTapGesture {
                                store.send(.tapDay(day))
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
                Circle()
                    .foregroundStyle(.mainGreen)
                    .frame(width: 24, height: 24)
                    .opacity(hasRecord ? 1 : 0)
                
                Text(String(day))
                    .font(Fonts.pretendardRegular(size: 12))
                    .foregroundColor(hasRecord ? .mainDeepDark : .gray300)
                    .padding(.vertical, 5)
            }
        }
    }
    
}

extension RUCalendar {
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

private extension RUCalendar {
    
    private func getWeekdaySymbols() -> [String] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.veryShortWeekdaySymbols
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
}
