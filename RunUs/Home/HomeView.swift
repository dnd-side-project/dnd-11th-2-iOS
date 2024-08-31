//
//  HomeView.swift
//  RunUs
//
//  Created by seungyooooong on 7/23/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    let store: StoreOf<HomeStore> = Store(
        initialState: HomeStore.State(),
        reducer: { HomeStore() }
    )
    
    var body: some View {
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
                AsyncImage(url: URL(string: store.weather.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .frame(height: 102)
            .padding(.bottom, 39)
            HStack(alignment: .bottom, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    // TODO: locationManager의 permission을 HomeView로 이동 + 현재 주소 가져오기 적용
                    // TODO: 위치 정보 제공 안할 시 HStack hide 및 서버로 서울 강남 위도 / 경도 전송
                    HStack(spacing: 0) {
                        Image(.location)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                            .padding(.horizontal, 1)
                        Text("서울시 강남구").font(Fonts.pretendardRegular(size: 12))
                    }
                    .frame(height: 20)
                    Text(store.weather.title)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    HStack(spacing: 4) {
                        HStack(spacing: 0) {
                            Text("체감온도 ")
                            Text("\(store.weather.sensoryTemperature)")
                            Text("℃")
                        }
                        HStack(spacing: 0) {
                            Text("\(store.weather.maximumTemperature)")
                            Text("℃/")
                            Text("\(store.weather.minimumTemperature)")
                            Text("℃")
                        }
                        .foregroundStyle(.gray300)
                        .font(Fonts.pretendardRegular(size: 10))
                    }
                    .font(Fonts.pretendardRegular(size: 12))
                }
                Text(store.weather.caption)
                    .lineSpacing(8)
                    .foregroundStyle(.gray100)
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .padding(.bottom, 28)
            MyRecordButton(action: {
                // TODO: running 화면으로 이동
            }, text: "오늘의 러닝 챌린지 및 목표설정")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(store.challenges) { challenge in
                        Button {
                            // TODO: 해당 challenge가 선택되어있는 running 화면으로 이동
                        } label: {
                            TodayChallengeListItemView(challenge: challenge, hasShadowPadding: false, backgroundColor: .mainDeepDark)
                        }
                    }
                }
                .padding(.horizontal, Paddings.outsideHorizontalPadding)
            }
            .padding(.horizontal, -Paddings.outsideHorizontalPadding)
            .padding(.bottom, 36)
            Text("이번 달 러닝 기록")
                .font(Fonts.pretendardBold(size: 16))
                .frame(height: 60)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(store.monthlySummary.month)
                    Text("에는")
                }
                .padding(.bottom, 4)
                HStack(spacing: 0) {
                    Text(store.monthlySummary.monthlyKm)
                        .foregroundStyle(.mainGreen)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text(" 달렸어요")
                    Spacer()
                }
                .padding(.bottom, 10)
                HStack(spacing: 0) {
                    Text(store.monthlySummary.nextLevelName)
                    Text("까지 ")
                    Text(store.monthlySummary.nextLevelKm)
                    Text(" 남았어요!")
                }
                .font(Fonts.pretendardRegular(size: 12))
            }
            .font(Fonts.pretendardMedium(size: 16))
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(.mainDeepDark)
            .cornerRadius(12)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .onAppear {
            store.send(.onAppear)
        }
    }
}
    

#Preview {
    HomeView()
}
