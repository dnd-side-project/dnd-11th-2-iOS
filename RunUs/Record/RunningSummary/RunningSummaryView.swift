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
            Text("KM")
                .font(Fonts.pretendardSemiBold(size: 20))
                .foregroundStyle(.white)
            Spacer().frame(height: 9)
            Text(store.distanceSummary.date)
                .font(Fonts.pretendardSemiBold(size: 12))
                .foregroundStyle(.gray300)
            Spacer().frame(height: 19)
            
            Chart {
                ForEach (store.distanceChartDatas) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating),
                        width: 25
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
            .RUChartAxisLabel(type: .distance)
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
                .font(Fonts.pretendardSemiBold(size: 20))
                .foregroundStyle(.white)
            Spacer().frame(height: 9)
            Text(store.timeSummary.date)
                .font(Fonts.pretendardSemiBold(size: 12))
                .foregroundStyle(.gray300)
            Spacer().frame(height: 19)
            
            Chart {
                ForEach (store.distanceChartDatas) { date in
                    BarMark(
                        x: .value("Day", date.day),
                        y: .value("Rating", date.rating),
                        width: 25
                    )
                }
            }
            .RUChartAxisLabel(type: .time)
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

extension Chart {
    func RUChartAxisLabel(type: SummaryTypes, color: Color = .gray300) -> some View {
        self.chartXAxis {
            AxisMarks { value in
                AxisValueLabel().foregroundStyle(color)
            }
        }
        .chartYAxis {
            AxisMarks { value in
                if let yValue = value.as(Double.self) {
                    AxisValueLabel(
                        "\(String(format: "%.0f", Double(yValue)))\(type.labelString)"
                    ).foregroundStyle(color)
                }
            }
        }
    }
}

#Preview {
    RunningSummaryView()
}
