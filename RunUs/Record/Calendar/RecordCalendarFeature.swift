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
        var currentRecord: RunningRecord?
    }
    
    enum Action {
        case binding(BindingAction<State>)
        case updateRecord
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
            case .binding(_):
                return .none
            case .updateRecord:
                //TODO: state.day를 기준으로 API호출
                return .none
            case .tapLeftButton:
                state.currentMonth = changeMonth(by: -1, month: state.currentMonth)
                return .send(.getRecordDays(state.currentMonth))
            case .tapRightButton:
                state.currentMonth = changeMonth(by: +1, month: state.currentMonth)
                return .send(.getRecordDays(state.currentMonth))
            case .tapDay(let day):
                state.currentDay = day
                return .send(.updateRecord)
            case .tapRecord:
                return .none
            case .getRecordDays(let date):
                return .run { send in
                    let (year, month) = dateFormatter(date: date)
                    let model = try await api.getMonthly(year: year, month: month)
                    await send(.updateRecordDays(model.days))
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
    
    private func getDay(date: String) -> Int? {
        guard let day = date.split(separator: "-").last else { return nil }
        return Int(day)
    }
}
