//
//  RunningRecordView.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct RunningRecordView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let store: StoreOf<RunningRecordStore> = .init(
        initialState: RunningRecordStore.State(),
        reducer: { RunningRecordStore() })
    
    @State var selectedDay: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "운동 기록")
                .padding(.horizontal, Paddings.outsideHorizontalPadding)
            ViewThatFits(in: .vertical) {
                runningRecordView
                ScrollView {
                    runningRecordView
                }
            }
        }
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension RunningRecordView {
    private var runningRecordView: some View {
        VStack {
            RUCalendar(store: store)
            Spacer().frame(height: 53)
            dailyRecordView
            Spacer()
        }
        .padding(Paddings.outsideHorizontalPadding)
    }
    
    private var dailyRecordView: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text(store.currentDaily)
                .font(Fonts.pretendardSemiBold(size: 16))
                .foregroundStyle(.white)
            if store.currentRecord.isEmpty {
                Text("운동 기록이 없습니다.")
                    .font(Fonts.pretendardMedium(size: 14))
                    .foregroundStyle(.gray200)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
            } else {
                ForEach(store.currentRecord) { record in
                    Button {
                        // TODO: runningRecordId로 API 추가되면 반영하기
//                        let navigationObject = NavigationObject(
//                            viewType: .runningResult,
//                            data: RunningResult(
//                                startAt: "",
//                                endAt: "",
//                                startLocation: record.startLocation,
//                                endLocation: record.endLocation,
//                                emotion: record.emoji.rawValue,
//                                challengeId: nil,
//                                goalDistance: 0,
//                                goalTime: 0,
//                                achievementMode: "",
//                                runningData: RunningData(
//                                    averagePace: record.averagePace,
//                                    runningTime: record.duration,
//                                    distanceMeter: record.distanceMeter,
//                                    calorie: record.calorie
//                                )
//                            )
//                        )
//                        viewEnvironment.navigationPath.append(navigationObject)
                    } label: {
                        recordView(record: record)
                    }
                }
            }
        }
    }
    
    private func recordView(record: RunningRecordDaily) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 11) {
                Image(record.emoji.icon)
                    .resizable()
                    .padding(3) // MARK: UI상 이미지 크기와 Assets에 저장되어있는 이미지 크기가 맞지 않아 적용
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 8) {
                    Text(record.startLocation)
                        .font(Fonts.pretendardRegular(size: 15))
                    Text("\(record.distanceMeter)km")
                        .font(Fonts.pretendardSemiBold(size: 22))
                }
                Spacer()
            }.padding(.horizontal, 15)
            HStack {
                recordText(title: "평균페이스", data: record.averagePace)
                Spacer()
                recordText(title: "시간", data: record.duration.formatToTime)
                Spacer()
                recordText(title: "칼로리", data: String(record.calorie))
            }.padding(.horizontal, 26)
        }
        .frame(height: 160)
        .foregroundStyle(.white)
        .background(Color.mainDeepDark)
        .cornerRadius(14)
    }
    
    private func recordText(title: String, data: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(Fonts.pretendardRegular(size: 12))
                .foregroundStyle(.gray200)
                .frame(height: 22)
            Text(data)
                .font(Fonts.pretendardBold(size: 20))
                .foregroundStyle(.white)
                .frame(height: 22)
        }
    }
}

#Preview {
    RunningRecordView()
}
