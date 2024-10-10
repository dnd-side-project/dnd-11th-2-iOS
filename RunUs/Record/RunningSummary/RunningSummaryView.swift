//
//  RunningSummaryView.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import SwiftUI
import Charts
import ComposableArchitecture

struct RunningSummaryView: View {
    @State var store: StoreOf<RunningSummaryStore> = Store(
        initialState: RunningSummaryStore.State(),
        reducer: { RunningSummaryStore() }
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "활동 요약")
            
            Text("KM")
                .foregroundStyle(.white)
            Text(store.distanceSummary.date)
                .foregroundStyle(.gray200)
            
            Chart {
                ForEach (store.distanceChartDatas) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating)
                    )
//                    .opacity(0.3)
//                    .annotation(position: .top, alignment: .center) {
//                        Text(date.rating.percentFormat())
//                            .font(.system(size: CGFloat.fontSize * 1.5))
//                    }
                    if store.distanceSummary.lastWeekAvgValue > 0 {
                        RuleMark(
                            y: .value("RatingOfWeek", store.distanceSummary.lastWeekAvgValue)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.gray100)
//                        .annotation(position: .top, alignment: .leading) {
//                            Text(store.distanceSummary.lastWeekAvgValue)
//                        }
                    }
                }
            }
//            .chartYScale(domain: 0 ... 100)
            .foregroundStyle(.mainGreen)
            .frame(height: 200)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.mainDeepDark.opacity(0.1))
            }
            
            Spacer()
            
            Text("시간")
                .foregroundStyle(.white)
            Text(store.timeSummary.date)
                .foregroundStyle(.gray200)
            
            Chart {
                ForEach (store.distanceChartDatas) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating)
                    )
                }
            }
            .foregroundStyle(.mainBlue)
            .frame(height: 200)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.mainDeepDark.opacity(0.1))
            }
            
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    RunningSummaryView()
}
