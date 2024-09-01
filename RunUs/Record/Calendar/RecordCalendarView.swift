//
//  RecordCalendarView.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct RecordCalendarView: View {
    let store: StoreOf<RecordCalendarFeature> = .init(
        initialState: RecordCalendarFeature.State(),
        reducer: { RecordCalendarFeature() })
    
    @State var selectedDay: Int = 0
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                RUNavigationBar(buttonType: .back, title: "운동 기록")
                RUCalendarView(store: store)
                    .padding(.bottom, 53)
                dailyRecordView
                Spacer()
            }
            .padding(Paddings.outsideHorizontalPadding)
        }
    }
}

extension RecordCalendarView {
    private var dailyRecordView: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text(DateFormatter.yyyyMM_dot.string(from: store.currentMonth) +
                 String(format: "%02d", store.currentDay))
                .font(Fonts.pretendardSemiBold(size: 16))
                .foregroundStyle(.white)
            VStack(spacing: 25) {
                HStack {
                    Image(.timeIcon)
                        .resizable()
                        .frame(width: 37, height: 37)
                    VStack(alignment: .leading) {
                        Text("서울 강남구 러닝")
                            .font(Fonts.pretendardRegular(size: 15))
                        Text("2.3km")
                            .font(Fonts.pretendardSemiBold(size: 22))
                    }
                    .foregroundStyle(.white)
                    Spacer()
                }.padding(.leading, 22)
                HStack {
                    recordText(title: "평균페이스", data: "0’00”")
                    Spacer()
                    recordText(title: "시간", data: "30:15")
                    Spacer()
                    recordText(title: "칼로리", data: "200")
                }.padding(.horizontal, 26)
            }
            .frame(height: 160)
            .background(Color.mainDeepDark)
            .cornerRadius(14, corners: .allCorners)
        }
    }
    
    //TODO: 러닝 화면에 있는 Text 컴포넌트화 해서 사용하기
    private func recordText(title: String, data: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(Fonts.pretendardRegular(size: 12))
                .foregroundStyle(.gray200)
            Text(data)
                .font(Fonts.pretendardBold(size: 20))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    RecordCalendarView()
}
