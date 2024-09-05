//
//  AchieveRecordView.swift
//  RunUs
//
//  Created by seungyooooong on 9/1/24.
//

import SwiftUI
import ComposableArchitecture

struct AchieveRecordView: View {
    let store: StoreOf<AchieveRecordStore> = Store(
        initialState: AchieveRecordStore.State(),
        reducer: { AchieveRecordStore() }
    )
    
    var body: some View {
        VStack(spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "달성기록", backgroundColor: .mainDeepDark)
                .padding(.horizontal, Paddings.outsideHorizontalPadding)
                .background(.mainDeepDark)
            VStack(spacing: 0) {
                HStack(spacing: 13) {
                    Image(.splash)  // TODO: API 나오면 수정
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .leading, spacing: 0) {
                        Text("LEVEL.1") // TODO: API 나오면 수정
                            .font(Fonts.pretendardBold(size: 24))
                        Text("50km 추가 달성 시 LV.2 달성")    // TODO: API 나오면 수정
                            .font(Fonts.pretendardMedium(size: 12))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.top, 30)
                .padding(.bottom, 28)
                RoundedRectangle(cornerRadius: 5)
                    .fill(.gray300)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.bottom, 29)
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("인천에서 대전") // TODO: API 나오면 수정
                            .foregroundStyle(.mainGreen)
                            .font(Fonts.pretendardBold(size: 15))
                        Text("대전까지 100km 남았어요!")    // TODO: API 나오면 수정
                            .font(Fonts.pretendardMedium(size: 10))
                    }
                    Spacer()
                    Text("현재 50m 달성")   // TODO: API 나오면 수정
                        .font(Fonts.pretendardSemiBold(size: 10))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 11)
                        .background(.mainBlue)
                        .cornerRadius(6)
                }
                .padding(.horizontal, 11)
                .padding(.bottom, 30)
            }
            .foregroundColor(.white)
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .background(.mainDeepDark)
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
            ViewThatFits(in: .vertical) {
                achieveRecordView
                ScrollView {
                    achieveRecordView
                }
            }
        }
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension AchieveRecordView {
    private var achieveRecordView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Image(.runEarthWithRunUs)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                VStack(alignment: .leading, spacing: 12) {
                    Text("런어스랑 지구한바퀴 달리기")
                        .foregroundStyle(.white)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    HStack(spacing: 8) {
                        Text("코스: \(store.state.courseSummary.courseCount)")
                        Text("런어스 총 거리: \(store.state.courseSummary.runUsDistanceKm)")
                        Text("지구 한 바퀴: \(store.state.courseSummary.earthDistanceKm)")
                    }
                    .foregroundStyle(.gray300)
                    .font(Fonts.pretendardSemiBold(size: 10))
                }
                Spacer()
            }
            .padding(.vertical, 26)
            // TODO: 반복문 추가
            AchieveRecordCardView(isCurrentAchieve: true)
            AchieveRecordCardView(isCurrentAchieve: false)
            AchieveRecordCardView(isCurrentAchieve: false, isEmptyView: true)
            AchieveRecordCardView(isCurrentAchieve: false)
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
}

struct AchieveRecordCardView: View {
    var isCurrentAchieve: Bool
    var isEmptyView: Bool
    var gradient: LinearGradient
    
    init(isCurrentAchieve: Bool, isEmptyView: Bool = false) {
        self.isCurrentAchieve = isCurrentAchieve
        self.isEmptyView = isEmptyView
        gradient = LinearGradient(colors: [.white, isCurrentAchieve ? .mainGreen : .mainDeepDark], startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                ZStack {
                    if isCurrentAchieve {
                        Circle()
                            .stroke(.mainGreen, lineWidth: 1)
                    }
                    Circle()
                        .fill(isCurrentAchieve ? .mainGreen : .mainDeepDark)
                        .frame(width: isCurrentAchieve ? 8 : 10)
                }
                .frame(width: 14, height: 14)
                DottedLine()
                    .frame(maxWidth: 1, maxHeight: .infinity)
                    .foregroundStyle(gradient)
            }
            HStack(spacing: 10) {
                if isEmptyView {
                    Text("다음 코스 공개까지 RUN with RUNUS!")
                        .font(Fonts.pretendardMedium(size: 12))
                } else {
                    Text("31.2km") // TODO: API 나오면 수정
                        .font(Fonts.pretendardBold(size: 12))
                        .foregroundStyle(isCurrentAchieve ? .white : .gray300)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 18)
                        .background(Color.background)
                        .cornerRadius(6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("서울에서 인천") // TODO: API 나오면 수정
                            .font(Fonts.pretendardBold(size: 14))
                        Text("2024. 08. 23.") // TODO: API 나오면 수정
                            .font(Fonts.pretendardMedium(size: 12))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .foregroundStyle(isCurrentAchieve ? .black : .gray300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 17)
            .background(isCurrentAchieve ? .mainGreen : .mainDeepDark)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 69)
        .padding(.bottom, 18)
    }
}

struct DottedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in  // MARK: 임의로 x position 설정
                path.move(to: CGPoint(x: 0.3, y: 0))
                path.addLine(to: CGPoint(x: 0.3, y: geometry.size.height))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 1]))
        }
    }
}

#Preview {
    AchieveRecordView()
}
