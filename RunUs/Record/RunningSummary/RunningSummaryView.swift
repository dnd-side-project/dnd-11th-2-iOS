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
            if store.state.isNoData() {
                Text("활동요약 확인을 위해서는\n러닝 데이터가 필요합니다!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .font(Fonts.pretendardMedium(size: 14))
                    .foregroundStyle(.gray200)
            } else {
                Spacer().frame(height: 20)
                runningSummaryChart(summaryType: .distance)
                Spacer()
                runningSummaryChart(summaryType: .time)
                Spacer()
            }
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func runningSummaryChart(summaryType: SummaryTypes) -> some View {
        let summary = store.state.summary(for: summaryType)
        return VStack(alignment: .leading, spacing: 0) {
            Text(summaryType.titleString)
                .font(Fonts.pretendardSemiBold(size: 20))
                .foregroundStyle(.white)
            Spacer().frame(height: 12)
            Text(summary.weeklyDate)
                .font(Fonts.pretendardSemiBold(size: 12))
                .foregroundStyle(.gray300)
            Spacer().frame(height: 20)
            
            Chart {
                ForEach(summary.weeklyValues, id: \.self.day) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating),
                        width: 18
                    )
                    .annotation(position: .top, alignment: .center) {
                        if date.rating > 0 {
                            Text(String(format: "%.1f", date.rating))
                                .font(Fonts.pretendardSemiBold(size: 10))
                                .foregroundStyle(.gray300)
                        }
                    }
                    if summary.lastWeekAvgValue > 0 {
                        RuleMark(
                            y: .value("lastWeekAvgValue", summary.lastWeekAvgValue)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.gray200)
                        .annotation(position: .top, alignment: .trailing) {
                            Text(String(format: "%.1f", summary.lastWeekAvgValue) + summaryType.labelString)
                                .font(Fonts.pretendardSemiBold(size: 12))
                                .foregroundStyle(.gray200)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel().foregroundStyle(.gray300)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    if let yValue = value.as(Double.self) {
                        if yValue > 0 {
                            AxisValueLabel(
                                String(format: yValue < 1  ? "%.1f" : "%.0f", yValue) + summaryType.labelString
                            ).foregroundStyle(.gray300)
                        }
                    }
                }
            }
            .foregroundStyle(summaryType.chartColor)
            .padding(.top, 40)
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.mainDeepDark)
            }
            .frame(height: 227)
        }
    }
}

#Preview {
    RunningSummaryView()
}
