//
//  HomeView.swift
//  RunUs
//
//  Created by seungyooooong on 7/23/24.
//

import SwiftUI

struct HomeView: View {
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    
    var body: some View {
        NavigationView {
            ViewThatFits(in: .vertical) {
                homeView
                ScrollView {
                    homeView
                }
            }
            .padding(.top, 1)   // MARK: ViewThatFits에서 ScrollView를 사용하면 SafeArea를 유지하기 위해 필요
            .background(Color.background)
        }
    }
}

extension HomeView {
    private var homeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.runus)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .padding(.top, 20)
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 0) {
                        Text("\(userName)님")
                            .foregroundStyle(.mainGreen)
                        Text(",")
                    }
                    Text("오늘도 힘내서 달려볼까요?")
                }
                .font(Fonts.pretendardBold(size: 20))
                Spacer()
                Image(.splash)   // TODO: 날씨 API 작업 이후 AsyncImage로 수정
                    .resizable()
                    .scaledToFit()
                    .padding(10)
            }
            .frame(height: 102)
            .padding(.bottom, 39)
            HStack(alignment: .bottom, spacing: 20) {    // TODO: 날씨 API 작업 이후 수정
                VStack(alignment: .leading, spacing: 6) {
                    Label(
                        // MARK: 위도 / 경도를 서버에서 보내달라고 함, 서울시 강남구를 프론트에서 표기할 수 있는지 확인
                        title: { Text("서울시 강남구").font(Fonts.pretendardRegular(size: 12)) },
                        icon: {
                            Image(.location)    // TODO: 현재 이미지 아이콘 우측이 조금 잘려서 추후에 디자이너분들께 다시 받아 수정
                                .resizable()
                                .scaledToFit()
                        }
                    )
                    .frame(height: 20)
                    Text("비내리는 날")
                        .font(Fonts.pretendardSemiBold(size: 16))
                    HStack(spacing: 4) {
                        HStack(spacing: 0) {
                            Text("체감온도 ")
                            Text("28")
                            Text("℃")
                        }
                        HStack(spacing: 0) {
                            Text("30")
                            Text("℃/")
                            Text("20")
                            Text("℃")
                        }
                        .foregroundStyle(.gray200)
                        .font(Fonts.pretendardRegular(size: 10))
                    }
                    .font(Fonts.pretendardRegular(size: 12))
                }
                // TODO: 줄바꿈, 폰트 색상, 위치 등 논의 후 수정
                Text("빗물이 고인 곳이 많을 수 있으니 달리며 미끄러지지 않도록 조심하세요")
                    .foregroundStyle(.gray100)
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .padding(.bottom, 28)
            MyRecordButton(action: {
                // TODO: running (아마 목표 설정) 화면으로 << 시나리오 확인 필요
            }, text: "오늘의 러닝 챌린지 및 목표설정")
            // TODO:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    // TODO: 반복문 추가 필요
                    Button {
                        // TODO: 혼자 뛰기를 시작하겠냐는 팝업을 띄운다던지.. 시나리오 상의 필요 (바로 카운트 다운으로 가면 이상할 듯..?)
                    } label: {
                        // TODO: background가 mainDeepDark인 케이스 추가 필요
                        TodayChallengeListItemView(challenge: TodayChallenge(id: 0, imageUrl: "", title: "어제보다 5분 더 뛰기", estimatedMinute: 5, isSelected: false))
                    }
                    Button {
                        // TODO: 혼자 뛰기를 시작하겠냐는 팝업을 띄운다던지.. 시나리오 상의 필요 (바로 카운트 다운으로 가면 이상할 듯..?)
                    } label: {
                        // TODO: background가 mainDeepDark인 케이스 추가 필요
                        TodayChallengeListItemView(challenge: TodayChallenge(id: 0, imageUrl: "", title: "어제보다 5분 더 뛰기", estimatedMinute: 5, isSelected: false))
                    }
                }
            }
            .padding(.horizontal, -Paddings.outsideHorizontalPadding)
            .padding(.leading, Paddings.outsideHorizontalPadding)
            .padding(.bottom, 36)
            Text("이번 달 러닝 기록")
                .font(Fonts.pretendardBold(size: 16))
                .frame(height: 60)
            VStack(alignment: .leading, spacing: 0) {   // TODO: API 작업 이후 수정
                HStack(spacing: 0) {
                    Text("7")
                    Text("월에는")
                }
                .padding(.bottom, 4)
                HStack(spacing: 0) {
                    Text("32km")
                        .foregroundStyle(.mainGreen)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text(" 달렸어요")
                    Spacer()
                }
                .padding(.bottom, 10)
                HStack(spacing: 0) {
                    Text("Level 2")
                    Text("까지 ")
                    Text("18km ")
                    Text("남았어요!")
                }
                .font(Fonts.pretendardRegular(size: 12))
            }
            .font(Fonts.pretendardMedium(size: 16))
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(.mainDeepDark)
            .cornerRadius(12)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
}
    

#Preview {
    HomeView()
}
