//
//  RunningSummaryView.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import SwiftUI
import Charts

struct RunningSummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "활동 요약")
            
            Text("KM")
                .foregroundStyle(.white)
            Text("2024.07.07. ~ 2024.07.14.")   // TODO: API 얀동
                .foregroundStyle(.gray200)
            
            Chart {
//                ForEach (calendarViewModel.ratingOnWeekForCharts) { date in
//                    BarMark(
//                        x: .value("Day", date.day),
//                        y: .value("Rating", date.rating)
//                    )
//                    .opacity(0.3)
//                    .annotation(position: .top, alignment: .center) {
//                        Text(date.rating.percentFormat())
//                            .font(.system(size: CGFloat.fontSize * 1.5))
//                    }
//                    if calendarViewModel.ratingOfWeek > 0 {
//                        RuleMark(
//                            y: .value("RatingOfWeek", calendarViewModel.ratingOfWeek)
//                        )
//                        .lineStyle(StrokeStyle(lineWidth: 2))
//                        .annotation(
//                            position:
//                                calendarViewModel.ratingOnWeekForCharts[0].rating == calendarViewModel.ratingOfWeek ||
//                            calendarViewModel.ratingOnWeekForCharts[1].rating == calendarViewModel.ratingOfWeek ||
//                            calendarViewModel.ratingOnWeekForCharts[2].rating == calendarViewModel.ratingOfWeek ? .bottom : .top
//                            , alignment: .leading
//                        ) {
//                            Text(" 주간 달성률 : \(Int(calendarViewModel.ratingOfWeek))%")
//                                .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
//                        }
//                    }
//                }
            }
//            .chartYScale(domain: 0 ... 100)
//            .foregroundStyle(.primary)
            .frame(height: 200)
            
            Spacer()
            
            Text("시간")
                .foregroundStyle(.white)
            Text("2024년 07월 07일 기준")   // TODO: API 얀동
                .foregroundStyle(.gray200)
            
            Chart {
                
            }
            .frame(height: 200)
            
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
    }
}

#Preview {
    RunningSummaryView()
}
