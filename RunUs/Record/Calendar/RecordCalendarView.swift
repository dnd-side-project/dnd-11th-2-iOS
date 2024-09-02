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
        ViewThatFits(in: .vertical) {
            recordCalendarView
            ScrollView {
                recordCalendarView
            }
        }
    }
}

extension RecordCalendarView {
    
    private var recordCalendarView: some View {
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
    
    private var dailyRecordView: some View {
        VStack {
            HStack {
                Text(store.currentDaily)
                    .font(Fonts.pretendardSemiBold(size: 16))
                    .foregroundStyle(.white)
                Spacer()
            }
            if store.currentRecord.isEmpty {
                HStack(alignment: .center) {
                    Text("운동 기록이 없습니다.")
                        .font(Fonts.pretendardMedium(size: 14))
                        .foregroundStyle(.gray200)
                        .padding(.top, 66)
                }
            } else {
                ForEach(store.currentRecord) { record in
                    recordView(record: record)
                }
            }
        }
    }
    
    private func recordView(record: RunningRecord) -> some View {
        VStack(spacing: 25) {
            HStack {
                Image(.timeIcon)
                    .resizable()
                    .frame(width: 37, height: 37)
                VStack(alignment: .leading) {
                    Text(record.startLocation)
                        .font(Fonts.pretendardRegular(size: 15))
                    Text("\(record.distanceMeter)km")
                        .font(Fonts.pretendardSemiBold(size: 22))
                }
                .foregroundStyle(.white)
                Spacer()
            }.padding(.leading, 22)
            HStack {
                recordText(title: "평균페이스", data: record.averagePace)
                Spacer()
                recordText(title: "시간", data: record.duration)
                Spacer()
                recordText(title: "칼로리", data: "\(record.calorie)")
            }.padding(.horizontal, 26)
        }
        .frame(height: 160)
        .background(Color.mainDeepDark)
        .cornerRadius(14, corners: .allCorners)
        .padding(.top, 26)
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
