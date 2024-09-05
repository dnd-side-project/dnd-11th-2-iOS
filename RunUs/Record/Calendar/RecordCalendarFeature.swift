//
//  RecordCalendarFeature.swift
//  RunUs
//
//  Created by Ryeong on 9/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RecordCalendarFeature {
    @ObservableState
    struct State {
        var currentMonth: Date = .now
        var currentDay: Int = Calendar.current.component(.day, from: Date())
        var recordDays: Set<Int> = []
        var currentDaily: String = DateFormatter.yyyyMMdd_dot.string(from: Date())
        var currentRecord: [RunningRecord] = []
    }
    
    enum Action {
        case onAppear
        case binding(BindingAction<State>)
        case updateRecord([RunningRecord])
        case tapLeftButton
        case tapRightButton
        case tapDay(Int)
        case tapRecord
        case getRecordDays(Date)
        case updateRecordDays([String])
    }
    
    let calendar = Calendar.current
    
    @Dependency(\.recordCalendarAPI) var api
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.getRecordDays(state.currentMonth))
            case .binding(_):
                return .none
            case .updateRecord(let record):
                state.currentRecord = record
                return .none
            case .tapLeftButton:
                state.currentMonth = changeMonth(by: -1, month: state.currentMonth)
                state.recordDays = []
                return .send(.getRecordDays(state.currentMonth))
            case .tapRightButton:
                state.currentMonth = changeMonth(by: +1, month: state.currentMonth)
                state.recordDays = []
                return .send(.getRecordDays(state.currentMonth))
            case .tapDay(let day):
                let currentMonth = state.currentMonth
                state.currentDay = day
                state.currentDaily = dateFormatter(currentMonth: currentMonth,
                                                   day: day,
                                                   split: ".") ?? DateFormatter.yyyyMMdd_dot.string(from: Date())
                return .run { send in
                    guard let date = dateFormatter(currentMonth: currentMonth, day: day, split: "-")
                    else { return }
                    do {
                        let model = try await api.getDaily(date: date)
                        await send(.updateRecord(model.records))
                    } catch(let error) {
                        print(error)
                    }
                }
            case .tapRecord:
                return .none
            case .getRecordDays(let date):
                return .run { send in
                    let (year, month) = dateFormatter(date: date)
                    do {
                        let model = try await api.getMonthly(year: year, month: month)
                        await send(.updateRecordDays(model.days))
                    } catch(let error) {
                        print(error)
                    }
                }
            case .updateRecordDays(let date):
                let days = date.compactMap { getDay(date: $0) }
                state.recordDays = Set(days)
                return .none
            }
        }
    }
}

extension RecordCalendarFeature {
    
    private func changeMonth(by value: Int, month: Date) -> Date {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            return newMonth
        }
        return .now
    }
    
    private func dateFormatter(date: Date) -> (yser: Int, month: Int) {
        let year: Int = calendar.component(.year, from: date)
        let month: Int = calendar.component(.month, from: date)
        return (year, month)
    }
    
    private func dateFormatter(currentMonth: Date, day: Int, split: String) -> String? {
        var component = calendar.dateComponents([.year, .month], from: currentMonth)
        component.day = day
        
        guard let date = calendar.date(from: component) else { return nil }
        
        if split == "-" {
            return DateFormatter.yyyyMMdd_hyphen.string(from: date)
        } else {
            return DateFormatter.yyyyMMdd_dot.string(from: date)
        }
    }
    
    private func getDay(date: String) -> Int? {
        guard let day = date.split(separator: "-").last else { return nil }
        return Int(day)
    }
}
