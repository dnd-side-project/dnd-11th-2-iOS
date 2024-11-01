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
            RUNavigationBar(buttonType: .back, title: "활동요약")
            if store.state.isNoData() {
                noData
            } else {
                Spacer().frame(height: 8)
                Text(store.distanceSummary.weeklyDate)  // TODO: 추후 API 형식이 바뀌면 수정
                    .font(Fonts.pretendardSemiBold(size: 14))
                    .foregroundStyle(.gray300)
                Spacer().frame(height: 31)
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
            HStack(alignment: .bottom) {
                Text(summaryType.titleString)
                    .font(Fonts.pretendardSemiBold(size: 20))
                Spacer()
                Text("지난주 평균 \(String(format: summary.lastWeekAvgValue == 0 ? "%.0f" : "%.1f", summary.lastWeekAvgValue) + summaryType.labelString)")
                    .font(Fonts.pretendardSemiBold(size: 12))
            }
            .foregroundStyle(.white)
            Spacer().frame(height: 16)
            Chart {
                ForEach(summary.weeklyValues, id: \.self.day) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating),
                        width: 18
                    )
                    .annotation(position: .top, alignment: .center) {
                        if date.rating > 0 {
                            Text(String(format: "%.1f", date.rating) + summaryType.labelString)
                                .font(Fonts.pretendardRegular(size: 10))
                                .foregroundStyle(.gray300)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(.gray300)
                        .font(Fonts.pretendardSemiBold(size: 12))
                }
            }
            .chartYAxis {
                let topRating = summary.weeklyValues.max(by: { $0.rating < $1.rating })?.rating ?? 0
                let strideValue = topRating > 0 ? topRating * 0.6 : 1   // MARK: 거리와 시간 API 응답 시간 차이가 있을 수 있어 1이라는 임시 값을 설정
                AxisMarks(values: .stride(by: strideValue)) { value in
                    if let yValue = value.as(Double.self) {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(.gray300)
                        if yValue > 0 {
                            AxisValueLabel(
                                String(format: yValue < 1  ? "%.1f" : "%.0f", yValue) + summaryType.labelString
                            )
                            .offset(y: -2)
                            .foregroundStyle(.gray300)
                            .font(Fonts.pretendardSemiBold(size: 10))
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

extension RunningSummaryView {
    var noData: some View {
        VStack(spacing: 13) {
            Image(.warning)
                .resizable()
                .scaledToFit()
                .frame(width: 27, height: 27)
            Text("주간 러닝 데이터가 없습니다.")
                .font(Fonts.pretendardMedium(size: 14))
                .foregroundStyle(.gray200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RunningSummaryView()
}
