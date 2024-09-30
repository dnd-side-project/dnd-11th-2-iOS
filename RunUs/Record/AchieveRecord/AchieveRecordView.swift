//
//  AchieveRecordView.swift
//  RunUs
//
//  Created by seungyooooong on 9/1/24.
//

import SwiftUI
import ComposableArchitecture

struct AchieveRecordView: View {
    let profile: ProfileResponseModel
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
                Spacer().frame(height: 30)
                HStack(spacing: 13) {
                    AsyncImage(url: URL(string: profile.profileImageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(profile.currentLevelName)
                            .font(Fonts.pretendardBold(size: 24))
                        Text("\(profile.nextLevelKm) 추가 달성 시 \(profile.nextLevelName) 달성")
                            .font(Fonts.pretendardMedium(size: 12))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                Spacer().frame(height: 28)
                RoundedRectangle(cornerRadius: 5)
                    .fill(.gray300)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                Spacer().frame(height: 29)
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(store.state.courses.currentCourse.name)
                            .foregroundStyle(.mainGreen)
                            .font(Fonts.pretendardBold(size: 15))
                        Text(store.state.courses.currentCourse.message)
                            .font(Fonts.pretendardMedium(size: 10))
                    }
                    Spacer()
                    Text("현재 \(store.state.courses.currentCourse.achievedDistance) 달성")
                        .font(Fonts.pretendardSemiBold(size: 10))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 11)
                        .background(.mainBlue)
                        .cornerRadius(6)
                }
                .padding(.horizontal, 11)
                Spacer().frame(height: 30)
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
                        Text("코스: \(store.state.courses.info.totalCourses)코스")
                        Text("런어스 총 거리: \(store.state.courses.info.totalDistance)")
                        Text("지구 한 바퀴: 40.075km")
                    }
                    .foregroundStyle(.gray300)
                    .font(Fonts.pretendardSemiBold(size: 10))
                }
                Spacer()
            }
            .padding(.vertical, 26)
            ForEach (store.state.courses.achievedCourses, id: \.self.name) { course in
                AchieveRecordCardView(distance: course.totalDistance, title: course.name, subTitle: course.achievedAt, isCurrentAchieve: true)
            }
            // TODO: 컴포넌트별 조건 정의 필요
            AchieveRecordCardView(distance: store.state.courses.currentCourse.totalDistance, title: store.state.courses.currentCourse.name, subTitle: store.state.courses.currentCourse.message)
            AchieveRecordCardView(isEmptyView: true)
            AchieveRecordCardView(distance: "40.075km", title: "지구한바퀴 완주!", subTitle: "축하합니다! 지구한바퀴 완주하셨네요!")
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
}

struct AchieveRecordCardView: View {
    var distance: String
    var title: String
    var subTitle: String
    var isCurrentAchieve: Bool
    var isEmptyView: Bool
    var gradient: LinearGradient
    
    init(distance: String, title: String, subTitle: String, isCurrentAchieve: Bool = false) {
        self.distance = distance
        self.title = title
        self.subTitle = subTitle
        self.isCurrentAchieve = isCurrentAchieve
        self.isEmptyView = false
        gradient = LinearGradient(colors: [.white, isCurrentAchieve ? .mainGreen : .mainDeepDark], startPoint: .top, endPoint: .bottom)
    }
    
    init(isEmptyView: Bool) {
        self.distance = ""
        self.title = ""
        self.subTitle = ""
        self.isCurrentAchieve = false
        self.isEmptyView = isEmptyView
        gradient = LinearGradient(colors: [.white, .mainDeepDark], startPoint: .top, endPoint: .bottom)
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
                    Text(distance)
                        .font(Fonts.pretendardBold(size: 12))
                        .foregroundStyle(isCurrentAchieve ? .white : .gray300)
                        .padding(.vertical, 13)
                        .frame(width: 76)
                        .background(Color.background)
                        .cornerRadius(6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(Fonts.pretendardBold(size: 14))
                        Text(subTitle)
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
        Spacer().frame(height: 18)
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
    AchieveRecordView(profile: ProfileResponseModel())
}
