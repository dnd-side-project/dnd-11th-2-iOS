//
//  RecordCalendarView.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct RecordCalendarView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
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
        .onAppear {
            store.send(.onAppear)
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
                Spacer().frame(height: 53)
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
                    Button {
                        let navigationObject = NavigationObject(
                            viewType: .runningResult,
                            data: RunningResult(    // TODO: 부족한 데이터들 채우기
                                startAt: "",
                                endAt: "",
                                startLocation: record.startLocation,
                                endLocation: record.endLocation,
                                emotion: record.emoji.rawValue,
                                challengeId: nil,
                                goalDistance: 0,
                                goalTime: 0,
                                achievementMode: "",
                                runningData: RunningData(
                                    averagePace: record.averagePace,
                                    runningTime: record.duration,
                                    distanceMeter: record.distanceMeter,
                                    calorie: record.calorie
                                )
                            )
                        )
                        viewEnvironment.navigationPath.append(navigationObject)
                    } label: {
                        recordView(record: record)
                    }
                }
            }
        }
    }
    
    private func recordView(record: RunningRecord) -> some View {
        VStack(spacing: 25) {
            HStack(spacing: 18) {
                Image(record.emoji.icon)
                    .resizable()
                    .frame(width: 37, height: 37)
                VStack(alignment: .leading, spacing: 10) {
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
