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
            Spacer().frame(height: 20)
            runningSummaryChart(summaryType: .distance)
            Spacer()
            runningSummaryChart(summaryType: .time)
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func runningSummaryChart(summaryType: SummaryTypes) -> some View {
        let summary = store.state.summary(for: summaryType)
        let chartDatas = store.state.chartDatas(for: summaryType)
        return VStack(alignment: .leading, spacing: 0) {
            Text(summaryType.titleString)
                .font(Fonts.pretendardSemiBold(size: 20))
                .foregroundStyle(.white)
            Spacer().frame(height: 12)
            Text(summary.date)
                .font(Fonts.pretendardSemiBold(size: 12))
                .foregroundStyle(.gray300)
            Spacer().frame(height: 20)
            
            Chart {
                ForEach(chartDatas) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating),
                        width: 18
                    )
    //                    .annotation(position: .top, alignment: .center) {
    //                        Text(date.rating.percentFormat())
    //                            .font(.system(size: CGFloat.fontSize * 1.5))
    //                    }
                    if summary.lastWeekAvgValue > 0 {
                        RuleMark(
                            y: .value("lastWeekAvgValue", summary.lastWeekAvgValue)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.gray100)
    //                        .annotation(position: .top, alignment: .leading) {
    //                            Text(store.distanceSummary.lastWeekAvgValue)
    //                        }
                    }
                }
            }
            .RUChartAxisLabel(summaryType: summaryType)
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

extension Chart {
    func RUChartAxisLabel(summaryType: SummaryTypes) -> some View {
        self.chartXAxis {
            AxisMarks { value in
                AxisValueLabel().foregroundStyle(.gray300)
            }
        }
        .chartYAxis {
            AxisMarks { value in
                if let yValue = value.as(Double.self) {
                    AxisValueLabel(
                        "\(String(format: "%.0f", Double(yValue)))\(summaryType.labelString)"
                    ).foregroundStyle(.gray300)
                }
            }
        }
    }
}

#Preview {
    RunningSummaryView()
}
