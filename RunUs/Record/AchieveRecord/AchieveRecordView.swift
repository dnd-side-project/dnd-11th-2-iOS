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
    @State var store: StoreOf<AchieveRecordStore> = Store(
        initialState: AchieveRecordStore.State(),
        reducer: { AchieveRecordStore() }
    )
    
    var body: some View {
        VStack(spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "달성기록", backgroundColor: .mainDeepDark)
                .padding(.horizontal, Paddings.outsideHorizontalPadding)
                .background(.mainDeepDark)
            VStack(spacing: .zero) {
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
                    .padding(.horizontal, -14)
                Spacer().frame(height: 15)
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("현재 \(store.state.courses.currentCourse.achievedDistance) 달성")
                            .font(Fonts.pretendardBold(size: 16))
                            .foregroundStyle(.mainGreen)
                        Text("완주까지 43,800km 남았어요!") // TODO: API 나오면 수정
                    }
                    Spacer()
                    Image(.Record.go)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .frame(width: 76, height: 76)
                }
//                RUProgress(percent: 90) // TODO: #84 머지 & API 나오면 수정
                Spacer().frame(height: 8)
                HStack {
                    Text("현재 17코스") // TODO: API 나오면 수정
                    Spacer()
                    Text("지구 한바퀴 완주")   // TODO: API 나오면 수정
                }
                Spacer().frame(height: 25)
            }
            .foregroundStyle(.white)
            .font(Fonts.pretendardMedium(size: 12))
            .padding(.horizontal, 30)
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
        VStack(alignment: .leading, spacing: .zero) {
            Spacer().frame(height: 30)
            Text("런어스랑 지구한바퀴 달리기")
                .foregroundStyle(.white)
                .font(Fonts.pretendardSemiBold(size: 16))
            HStack(spacing: 8) {
                Text("코스: \(store.state.courses.info.totalCourses)코스")
                Text("런어스 총 거리: \(store.state.courses.info.totalDistance)")
            }
            .foregroundStyle(.gray300)
            .font(Fonts.pretendardSemiBold(size: 12))
            Spacer().frame(height: 25)
            ForEach (store.state.courses.achievedCourses, id: \.self.name) { course in
                AchieveRecordCardView(distance: course.totalDistance, title: course.name, subTitle: course.achievedAt, recordType: .achieved)  // TODO: 완주 코스
            }
            AchieveRecordCardView(distance: store.state.courses.currentCourse.totalDistance, title: store.state.courses.currentCourse.name, subTitle: store.state.courses.currentCourse.message, recordType: .running) // TODO: 현재 코스
            // TODO: 다음 코스 (회색) recordType: .next
            if true {   // TODO: 현재 달리는 코스가 마지막 코스보다 적으면
                AchieveRecordCardView(hasNextCourse: true)
            }
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
}

struct AchieveRecordCardView: View {
    var distance: String
    var title: String
    var subTitle: String
    var recordType: RecordTypes
    var hasNextCourse: Bool
    var gradient: LinearGradient
    
    init(distance: String, title: String, subTitle: String, recordType: RecordTypes) {
        self.distance = distance
        self.title = title
        self.subTitle = subTitle
        self.recordType = recordType
        self.hasNextCourse = false
        gradient = LinearGradient(colors: [.white, recordType == .running ? .mainGreen : .mainDeepDark], startPoint: .top, endPoint: .bottom)
    }
    
    init(hasNextCourse: Bool) {
        self.distance = ""
        self.title = ""
        self.subTitle = ""
        self.recordType = .next
        self.hasNextCourse = hasNextCourse
        gradient = LinearGradient(colors: [.white, .mainDeepDark], startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                ZStack {
                    if recordType == .running {
                        Circle()
                            .stroke(.mainGreen, lineWidth: 1)
                    }
                    Circle()
                        .fill(recordType == .running ? .mainGreen : .mainDeepDark)
                        .frame(width: recordType == .running ? 16 : 10)
                    if recordType == .running {
                        Text("17")  // TODO: API 나오면 수정
                            .font(Fonts.pretendardSemiBold(size: 10))
                            .foregroundStyle(.black)
                    }
                }
                .frame(width: 20, height: 20)
                DottedLine()
                    .frame(maxWidth: 1, maxHeight: .infinity)
                    .foregroundStyle(gradient)
            }
            HStack(spacing: 10) {
                if hasNextCourse {
                    Text("다음 코스 공개까지 RUN with RUNUS!")
                        .font(Fonts.pretendardMedium(size: 12))
                } else {
                    Text(distance)
                        .font(Fonts.pretendardBold(size: 12))
                        .foregroundStyle(recordType == .achieved ? .black : recordType == .running ? .white : .gray300)
                        .padding(.vertical, 13)
                        .frame(width: 76)
                        .background(recordType == .achieved ? .mainGreen : Color.background)
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
            .foregroundStyle(recordType == .achieved ? .white : recordType == .running ? .black : .gray300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 17)
            .background(recordType == .running ? .mainGreen : .mainDeepDark)
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

enum RecordTypes {
    case achieved
    case running
    case next
}

#Preview {
    AchieveRecordView(profile: ProfileResponseModel())
}
