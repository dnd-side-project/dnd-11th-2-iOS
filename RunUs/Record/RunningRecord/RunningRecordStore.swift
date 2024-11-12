//
//  RunningRecordStore.swift
//  RunUs
//
//  Created by Ryeong on 9/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RunningRecordStore {
    @ObservableState
    struct State {
        var currentMonth: Date = .now
        var currentDay: Int = Calendar.current.component(.day, from: Date())
        var recordDays: Set<Int> = []
        var currentDaily: String = DateFormatter.yyyyMMdd_dot.string(from: Date())
        var currentRecord: [RunningRecordDaily] = []
    }
    
    enum Action {
        case onAppear
        case binding(BindingAction<State>)
        case updateRecord([RunningRecordDaily])
        case tapLeftButton
        case tapRightButton
        case tapDay(Int)
        case tapRecord
        case getRecordDays
        case updateRecordDays([String])
    }
    
    let calendar = Calendar.current
    
    @Dependency(\.runningRecordAPI) var runningRecordAPI
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let day = state.currentDay
                return .run { send in
                    await send(.getRecordDays)
                    await send(.tapDay(day))
                }
            case .binding(_):
                return .none
            case .updateRecord(let record):
                state.currentRecord = record
                return .none
            case .tapLeftButton:
                state.currentMonth = changeMonth(by: -1, month: state.currentMonth)
                state.recordDays = []
                return .send(.getRecordDays)
            case .tapRightButton:
                state.currentMonth = changeMonth(by: +1, month: state.currentMonth)
                state.recordDays = []
                return .send(.getRecordDays)
            case .tapDay(let day):
                let currentMonth = state.currentMonth
                state.currentDay = day
                state.currentDaily = dateFormatter(currentMonth: currentMonth, day: day, split: ".") ?? DateFormatter.yyyyMMdd_dot.string(from: Date())
                return .run { send in
                    guard let date = dateFormatter(currentMonth: currentMonth, day: day, split: "-") else { return }
                    await RUNetworkManager.task(
                        action: { try await runningRecordAPI.getDaily(date: date) },
                        successAction: { await send(.updateRecord($0.records)) },
                        retryAction: { await send(.tapDay(day)) }
                    )
                }
            case .tapRecord:
                return .none
            case .getRecordDays:
                let date = state.currentMonth
                return .run { send in
                    let (year, month) = dateFormatter(date: date)
                    await RUNetworkManager.task(
                        action: { try await runningRecordAPI.getMonthly(year: year, month: month) },
                        successAction: { await send(.updateRecordDays($0.days)) },
                        retryAction: { await send(.getRecordDays) }
                    )
                }
            case .updateRecordDays(let date):
                let days = date.compactMap { getDay(date: $0) }
                state.recordDays = Set(days)
                return .none
            }
        }
    }
}

extension RunningRecordStore {
    
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
